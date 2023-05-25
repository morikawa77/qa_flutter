import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qa_flutter/components/header.dart';
import 'package:qa_flutter/login.dart';
import 'package:qa_flutter/theme.dart';
import 'package:routemaster/routemaster.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _errorMessageController = TextEditingController();
  final _anonymousAuth = AnonymousAuth();
  final _emailPasswordAuth = EmailPasswordAuth();
  final _emailPasswordRegistration = EmailPasswordRegistration();

  void _loginAnonymously() async {
    UserCredential? userCredential = await _anonymousAuth.signInAnonymously();
    if (userCredential != null) {
      _emailController.text = '';
      _passwordController.text = '';
      Routemaster.of(context).push('/home');
    } else {
      setState(() {
        _errorMessageController.text = 'Erro ao fazer login anônimo';
      });
    }
  }

  void _loginWithEmailPassword() async {
    UserCredential? userCredential = await _emailPasswordAuth.signInWithEmailPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (userCredential != null) {
      _emailController.text = '';
      _passwordController.text = '';
      Routemaster.of(context).push('/home');
    } else {
      setState(() {
        _errorMessageController.text = 'Credenciais inválidas';
      });
    }
}

  void _createUserWithEmailPassword() async {
    UserCredential? userCredential = await _emailPasswordRegistration.registerWithEmailPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (userCredential != null) {
      _emailController.text = '';
      _passwordController.text = '';
      Routemaster.of(context).push('/home');
    } else {
      setState(() {
        _errorMessageController.text = 'Erro ao criar novo usuário';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(showLogoutButton: false, context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 72),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyTheme.inputBackgroundColor,
                  labelText: 'Digite aqui o seu usuário',
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
                    return 'Por favor, insira um usuário válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyTheme.inputBackgroundColor,
                  labelText: 'Digite aqui a sua senha',
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
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha válida';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              Row (
                children: [
                  Expanded(
                    child:
                      ElevatedButton(
                        onPressed: _loginWithEmailPassword,
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
                        child: const Text('Entrar'),
                      ),
                  ),

                  const SizedBox(width: 34),

                  Expanded(child: 
                    ElevatedButton(
                      onPressed: _createUserWithEmailPassword,
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
                      child: const Text('Criar usuário'),
                    ),
                  ),
                ],
              ),
              
              
              const SizedBox(height: 122.0,),

              ElevatedButton(
                onPressed: _loginAnonymously,
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
                child: const Text('Entrar anonimamente'),
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
                      style: _errorMessageController.text == '' ?BorderStyle.none : BorderStyle.solid,
                      // style: BorderStyle.none,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: MyTheme.error, 
                      width:  3,
                      style: _errorMessageController.text == '' ?BorderStyle.none : BorderStyle.solid,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: MyTheme.error, 
                      width:  3,
                      style: _errorMessageController.text == '' ?BorderStyle.none : BorderStyle.solid,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: MyTheme.error, 
                      width:  3,
                      style: _errorMessageController.text == '' ?BorderStyle.none : BorderStyle.solid,
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
}
