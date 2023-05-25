import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_flutter/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qa_flutter/components/header.dart';
import 'package:qa_flutter/qa.dart';
import 'package:qa_flutter/services/format_time_elapsed.dart';
import 'package:qa_flutter/services/copy_to_clipboard.dart';



class Admin extends StatefulWidget {
  final String code;
  
  // ignore: use_key_in_widget_constructors
  const Admin({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final User? user = _auth.currentUser;
    final code = widget.code;
    
    Query qaQuery = db.collection('qas').where(FieldPath.documentId, isEqualTo: code);

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
          String? userId = data['userId'] as String?;
          Timestamp? qaDatetime = data['qaDatetime'] as Timestamp?;
          List<dynamic>? questions = data['questions'] as List<dynamic>?;

          List<Question>? typedQuestions;
          if (questions != null) {
            typedQuestions = questions.map((dynamic item) {
              return Question.fromJson(item as Map<String, dynamic>);
            }).toList();
          }

          Qa qa = Qa(id, userId, qaDatetime, typedQuestions);

          String qaFormatedDateTime = formatTimeElapsed(qaDatetime!);

          String questionsCount = questions != null ? questions.length.toString() : '0';

          // print(data);
          // print(qa.userId);
          // print(DateFormat('dd/MM/yyyy - HH:mm:ss').format(qa.qaDatetime!.toDate()));
          // print(qa.questions);
      
          return Padding(
            padding: const EdgeInsets.all(34.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    QrImageView(
                      data: 'https://qaflutterfatec.vercel.com/#/participant/$code',
                      version: QrVersions.auto,
                      size: 160,
                      gapless: false,
                      backgroundColor: const Color(0xFFFFFFFF),
                      padding: const EdgeInsets.all(10),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Participe \ndo Q&A',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MyTheme.white,
                              fontFamily: 'IowanOldStyle',
                              fontSize: 36.0,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Código: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MyTheme.white,
                              fontFamily: 'IowanOldStyle',
                              fontSize: 18.0,
                            ),
                          ),
                          Row(
                            children: [
                              SelectableText(
                                '$code',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: MyTheme.white,
                                  fontFamily: 'IowanOldStyle',
                                  fontSize: 18.0,
                                ),
                              ),
                              IconButton(
                                onPressed: () => copyToClipboard(code), 
                                icon: const Icon(Icons.content_copy, size: 18, color: MyTheme.white)
                                )
                            ],
                          ),
                        ],
                      ),
                    )
                  ]
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
                          Question question = typedQuestions![index];
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

                          void addAnswerToQuestion(int questionIndex, String answer) async {
                            try {
                              // Acessar o documento "qa" no Firestore
                              DocumentReference qaRef = FirebaseFirestore.instance.collection('qas').doc(code);
                              DocumentSnapshot qaSnapshot = await qaRef.get();

                              if (qaSnapshot.exists) {
                                // Acessar a lista de perguntas dentro do documento "qa"
                                Map<String, dynamic>? qaData = qaSnapshot.data() as Map<String, dynamic>?;
                                List<dynamic> questionsData = qaData?['questions'] as List<dynamic>;

                                List<Question> questions = questionsData.map((question) => Question.fromJson(question)).toList();

                                // Verificar se o índice da pergunta é válido
                                if (questionIndex >= 0 && questionIndex < questions.length) {
                                  // Acessar a pergunta pelo índice
                                  Question question = questions[questionIndex];

                                  // Atualizar a resposta da pergunta
                                  question.answer = answer;

                                  // Atualizar a lista de perguntas no documento "qa"
                                  List<Map<String, dynamic>> updatedQuestions = questions.map((q) => q.toJson()).toList();
                                  await qaRef.update({'questions': updatedQuestions});

                                  print('Resposta adicionada com sucesso.');
                                } else {
                                  print('Índice de pergunta inválido.');
                                }
                              } else {
                                print('Documento "qa" não encontrado.');
                              }
                            } catch (e) {
                              print('Erro ao adicionar resposta: $e');
                            }
                          }



                          void showAnswerDialog(BuildContext context, String questionId) {
                            String answer = '';
                            int questionIndex = qa.questions!.indexWhere((q) => q.questionId == questionId);


                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Responder'),
                                  content: TextField(
                                    onChanged: (value) {
                                      answer = value;
                                    },
                                    decoration: const InputDecoration(hintText: 'Digite sua resposta'),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Fechar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Enviar resposta'),
                                      onPressed: () {
                                        addAnswerToQuestion(questionIndex, answer);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
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
                                    onPressed: null,
                                  ),
                                ],
                              ),
                              onTap: () => showAnswerDialog(context, questionId!),
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
              ]
            ),
          );
        },
      ),
    );
  }
}
