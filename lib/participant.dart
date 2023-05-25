import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_flutter/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qa_flutter/components/header.dart';
import 'package:qa_flutter/qa.dart';
import 'package:uuid/uuid.dart';
import 'package:qa_flutter/services/format_time_elapsed.dart';



class Participant extends StatefulWidget {
  final String code;
  
  // ignore: use_key_in_widget_constructors
  const Participant({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ParticipantState createState() => _ParticipantState();
}

class _ParticipantState extends State<Participant> {
  final TextEditingController _questionController = TextEditingController();

  DocumentSnapshot? currentSnapshot;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final User? user = _auth.currentUser;
    final code = widget.code;
    
    Query qaQuery = db
      .collection('qas')
      .where(FieldPath.documentId, isEqualTo: code);

    return Scaffold(
      appBar: Header(showLogoutButton: true, context: context),
      body: StreamBuilder<QuerySnapshot>(
        stream: qaQuery.snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            // ignore: avoid_print
            print(snapshot.error);
            return Text('Erro: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty ) {
            return const Center(child: Text('Nenhum documento encontrado'));
          }

          final data = snapshot.data!.docs[0];

          String? id = code;
          String? userId = data!['userId'] as String?;
          Timestamp? qaDatetime = data['qaDatetime'] as Timestamp?;
          List<dynamic>? questions = data['questions'] as List<dynamic>?;

          // List<Question>? typedQuestions;
          // if (questions != null) {
          //   typedQuestions = questions.map((dynamic item) {
          //     return Question.fromJson(item as Map<String, dynamic>);
          //   }).toList();

          //   typedQuestions.sort((a, b) {
          //     // Primeiro, comparar por questionVotes em ordem decrescente
          //     int votesComparison = b.questionVotes!.compareTo(a.questionVotes!);
          //     if (votesComparison != 0) {
          //       return votesComparison;
          //     }

          //     // Em seguida, comparar por questionDatetime em ordem decrescente
          //     return b.questionDatetime!.compareTo(a.questionDatetime!);
          //   });
          // }
          List<QuestionWithIndex>? typedQuestions;

          if (questions != null) {
            typedQuestions = questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = Question.fromJson(entry.value as Map<String, dynamic>);
              return QuestionWithIndex(index: index, question: question);
            }).toList();

            typedQuestions.sort((a, b) {
              // First, compare by questionDatetime in descending order
              int datetimeComparison = b.question.questionDatetime!
                  .compareTo(a.question.questionDatetime!);
              if (datetimeComparison != 0) {
                return datetimeComparison;
              }

              // Next, compare by questionVotes in descending order
              return b.question.questionVotes!.compareTo(a.question.questionVotes!);
            });
          }


          if (currentSnapshot != null && currentSnapshot != data) {
            currentSnapshot = data;
          }
         

          // Qa qa = Qa(id, userId, qaDatetime, typedQuestions);
          Qa qa = Qa(id, userId, qaDatetime, typedQuestions!.cast<Question>());

          String qaFormatedDateTime = formatTimeElapsed(qaDatetime!);

          String questionsCount = questions != null ? questions.length.toString() : '0';

          Future<void> addQuestionToQa(String qaId, Question newQuestion) async {
            try {
              DocumentReference docRef = db.collection('qas').doc(qaId);

              DocumentSnapshot snapshot = await docRef.get();
              if (snapshot.exists) {
                Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

                try {
                  if (data['questions'] != null) {
                    List<dynamic> questionDataList = data['questions'] as List<dynamic>;
                    List<Question> existingQuestions = questionDataList.map((item) => Question.fromJson(item as Map<String, dynamic>)).toList();
                    existingQuestions.add(newQuestion);

                    List<Map<String, dynamic>> updatedQuestions = existingQuestions.map((question) => question.toJson()).toList();

                    await docRef.update({'questions': updatedQuestions});

                    print('Pergunta adicionada com sucesso à Qa $qaId');
                  } else {

                    List<Map<String, dynamic>> updatedQuestions = [newQuestion.toJson()];

                    await docRef.update({'questions': updatedQuestions});

                    print('Pergunta adicionada com sucesso à Qa $qaId');
                  }
                } catch (e) {
                  print('Erro ao converter lista de perguntas: $e');
                }
              } else {
                print('Qa com ID $qaId não encontrada');
              }
            } catch (error) {
              print('Erro ao adicionar pergunta à Qa: $error');
            }
          }

          // print(data);
          // print(qa.userId);
          // print(DateFormat('dd/MM/yyyy - HH:mm:ss').format(qa.qaDatetime!.toDate()));
          // print(qa.questions);
      
          return Padding(
            padding: const EdgeInsets.fromLTRB(34, 34, 34, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _questionController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyTheme.inputBackgroundColor,
                          labelText: 'Digite sua pergunta',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'IowanOldStyle',
                            color: MyTheme.inputFontColor,
                            backgroundColor: MyTheme.inputBackgroundColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: MyTheme.inputFontColor,
                              width: 2,
                            ),
                          ) ,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.inputFontColor),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.inputBackgroundColor),
                          ),
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        minLines: 4,
                      ),
                      const SizedBox(height: 14.0,),
                      SizedBox(
                        height: 42,
                        width: double.infinity,
                        child: FractionallySizedBox(
                          widthFactor: 1.0,
                          child: ElevatedButton(
                            onPressed: () => {
                              addQuestionToQa(qa.id!, Question(
                                questionId: const Uuid().v4(),
                                question: _questionController.text,
                                questionOwnerId: user!.uid,
                                questionOwnerEmail: user!.email != null ? user!.email : 'Anônimo',
                                questionVotes: 0,
                                questionDatetime: Timestamp.now(),
                                answer: '', 
                              )),
                              _questionController.clear(),
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(MyTheme.accent),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(
                                  fontSize: 16, 
                                  fontFamily: 'IowanOldStyle',
                                )
                              ), 
                              foregroundColor: MaterialStateProperty.all<Color>(MyTheme.black),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: MyTheme.black))), 
                            ),
                            child: const Text('Enviar pergunta'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34.0,),
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Text(
                        //   'Q&A criada a $qaFormatedDateTime',
                        //   style: TextStyle(
                        //     color: MyTheme.white,
                        //   ),
                        // ),
                        Text(
                          '$questionsCount ',
                          style: const TextStyle(
                            color: MyTheme.white,
                          ),
                        ),
                        const Icon(
                          Icons.question_answer,
                          color: MyTheme.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                
                Flexible(
                  child: 
                  questions != null ?
                      ListView.builder(
                        // itemCount: questions != null ? questions.length : 0,
                        itemCount: typedQuestions != null ? typedQuestions.length : 0,

                        itemBuilder: (context, index) {
                          Question question = typedQuestions![index] as Question;
                          // print(question.questionId);
                          // print(question.question);
                          // print(question.questionVotes);
                          // print(question.questionDatetime);
                          // print(question.questionOwnerId);
                          // print(question.answer);

                          String? questionId = question.questionId;
                          String? questionText = question.question;
                          // String? questionOwnerId = question.questionOwnerId;
                          String? questionOwnerEmail = question.questionOwnerEmail;
                          int? questionVotes = question.questionVotes;
                          Timestamp? questionDatetime = question.questionDatetime;
                          String? answer = question.answer == null ? '' : question.answer;

                          String? formatedDateTime = formatTimeElapsed(questionDatetime!);

                          updateQuestionVotes(int questionIndex) async {
                            if (qa.id != null && questionIndex >= 0 && questionIndex < typedQuestions!.length) {
                              final questionWithIndex = typedQuestions[questionIndex];
                              final question = questionWithIndex.question;
                            }
                          }

                          return Card(
                            margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: const Icon(Icons.person),
                              title: Text(
                                questionOwnerEmail!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: MyTheme.black,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formatedDateTime),
                                  const Text('\n'),
                                  Text(
                                    questionText!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: MyTheme.black,
                                    )
                                  ),
                                  Visibility(
                                    visible: answer != "",
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: MyTheme.accent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: MyTheme.primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Transform.rotate(
                                            angle: 180 * 0.0174533, // Converter graus para radianos
                                            child: const Icon(Icons.turn_left),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   user!.email!,
                                              // ),
                                              Text(
                                                answer!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: MyTheme.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(questionVotes!.toString()),
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: questionVotes >= 1 ? MyTheme.accent : Colors.grey,
                                    ),
                                    onPressed: () => updateQuestionVotes(index),
                                  ),
                                ],
                              ),
                              onTap: null,
                            ),
                          );
                        },
                      )
                      :
                      const Text(
                        'Não há perguntas',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: MyTheme.white,
                          fontFamily: 'IowanOldStyle',
                          fontSize: 24.0,
                        ),
                      ),
                ),
              ],
            ),
          );
        }
      )
    );
  }
}


