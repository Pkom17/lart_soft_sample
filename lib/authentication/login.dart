import 'package:dno_app/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/views/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userName = TextEditingController();
  final password = TextEditingController();

  String passwordErrorMessage = '';
  bool passwordIsValid = false;
  bool isLoginTrue = false;

  bool passwordIsVisible = false;
  final db = DatabaseHelper();

  registerAccount() async {
    
  }

  login() async {
    var resp = await db
        .login(UserModel(userName: userName.text, password: password.text));
    UserModel? user = await db.getUser(userName.text);
    if (resp == true) {
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    profile: user,
                  )));
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Veuillez vous connecter",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  Image.asset(
                    "images/login.png",
                    width: 210,
                  ),
                  const SizedBox(height: 15),
                  //username textField
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: userName,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Identifiant obligatoire !";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Votre identifiant",
                      ),
                    ),
                  ),
                  //Password textField
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Mot de passe obligatoire !";
                        }
                        return null;
                      },
                      obscureText: !passwordIsVisible,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Mot de passe",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordIsVisible = !passwordIsVisible;
                              });
                            },
                            icon: Icon(passwordIsVisible
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //login button
                  Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurple),
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: const Text(
                            "Se connecter",
                            style: TextStyle(color: Colors.white),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Pas encore de compte ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text("Créez-vous un identfiant"))
                    ],
                  ),
                  isLoginTrue
                      ? const Text(
                          "Identifiant ou mot de passe incorrect",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
