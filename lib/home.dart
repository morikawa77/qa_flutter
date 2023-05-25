import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qa_flutter/components/header.dart';
import 'package:qa_flutter/theme.dart';
import 'package:routemaster/routemaster.dart';

class Home extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Home();

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _qacodecontroller = TextEditingController();
  final _errorMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final User? user;

    if (_auth.currentUser != null) {
      user = _auth.currentUser;
      print(user);
    } else {
      user = null;
      Routemaster.of(context).push('/login');
    }
    
    return Scaffold(
      appBar: Header(showLogoutButton: true, context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 72),
              TextFormField(
                controller: _qacodecontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyTheme.inputBackgroundColor,
                  labelText: 'Digite o código do Q&A',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um código válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => goParticipant(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(MyTheme.accent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(9, 24, 9, 24)), 
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 16, 
                      fontFamily: 'IowanOldStyle',
                    )
                  ), 
                  foregroundColor: MaterialStateProperty.all<Color>(MyTheme.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: MyTheme.black))), 
                ),
                child: const Text('Entrar na sessão'),
              ),
              
              
              const SizedBox(height: 122.0,),

              ElevatedButton(
                onPressed: () async {
                  if (!user!.isAnonymous) {
                    String code;
                    await db.collection('qas').add({
                      'userId': user.uid,
                      'qaDatetime': Timestamp.now(),
                      'questions': [],
                    }).then((docRef) => {
                      code = docRef.id,
                      // ignore: avoid_print
                      print(code),
                      Routemaster.of(context).push('/admin/$code'),
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Aviso'),
                          content: const Text('Você precisa estar logado não anonimamente para poder criar um novo Q&A'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Routemaster.of(context).push('/login');
                              },
                              child: const Text('Logar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(MyTheme.accent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(9, 24, 9, 24)), 
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 16, 
                      fontFamily: 'IowanOldStyle',
                    )
                  ), 
                  foregroundColor: MaterialStateProperty.all<Color>(MyTheme.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: MyTheme.black))), 
                ),
                child: const Text('Criar Q&A'),
              ),

              const SizedBox(height: 16.0,),

              TextFormField(
                controller: _errorMessageController,
                decoration: InputDecoration(
                  labelText: '',
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.error,
                    fontFamily: 'IowanOldStyle',
                  ),
                  enabled: false,
                  contentPadding: const EdgeInsets.fromLTRB(9, 24, 9, 24),
                  errorStyle: const TextStyle(
                    color: MyTheme.error,
                    fontFamily: 'IowanOldStyle',
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: MyTheme.error, 
                      width:  3,
                      style: _errorMessageController.text == '' ? BorderStyle.none : BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: MyTheme.error, 
                      width:  3,
                      style: _errorMessageController.text == '' ? BorderStyle.none : BorderStyle.solid,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: MyTheme.error, 
                      width:  3,
                      style: _errorMessageController.text == '' ? BorderStyle.none : BorderStyle.solid,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: MyTheme.error, 
                      width:  3,
                      style: _errorMessageController.text == '' ? BorderStyle.none : BorderStyle.solid,
                    ),
                  ),
                ),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  goParticipant() {
    String code = _qacodecontroller.text;
    code != '' ?
      Routemaster.of(context).push('/participant/$code')
    :
      _errorMessageController.text == 'Digite um código válido';
  }
}