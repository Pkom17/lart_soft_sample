import 'package:flutter/material.dart';
import 'package:dno_app/SQLite/sqlite.dart';
import 'package:dno_app/authentication/login.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/utils/utils.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final userName = TextEditingController();
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final phoneContact = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  String passwordErrorMessage = '';
  bool passwordIsValid = false;

  String requestResult = "";

  var userTypes = [
    "CONVOYEUR",
    "BIOLOGISTE",
  ];

  String userTypeSelected = "CONVOYEUR";
  bool passwordIsVisible = false;
  bool passwordIsVisible2 = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "Créer un nouveau compte",
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ),
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
                        icon: Icon(Icons.login),
                        border: InputBorder.none,
                        hintText: "Votre identifiant",
                        labelText: "Votre identifiant",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: lastName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nom obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Votre nom",
                        labelText: "Votre nom",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: firstName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Prénom obligatoire !";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Votre prénom",
                        labelText: "Votre prénom",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: phoneContact,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Numéro de téléphone obligatoire !";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                        border: InputBorder.none,
                        hintText: "Votre numéro de téléphone",
                        labelText: "Votre numéro de téléphone",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(),
                        hintText: "Type d'utilisateur",
                        labelText: "Type d'utilisateur",
                      ),
                      value: userTypeSelected,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: userTypes.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          userTypeSelected = newValue!;
                        });
                      },
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
                        } else if (!Utils.validatePassword(
                            value, passwordErrorMessage)) {
                          return "Mot de passe non valide \n$passwordErrorMessage";
                        }
                        return null;
                      },
                      obscureText: !passwordIsVisible,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Mot de passe",
                        labelText: "Mot de passe",
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
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: confirmPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Mot de passe obligatoire !";
                        } else if (password.text != confirmPassword.text) {
                          return "Les mots de passe ne correspondent pas";
                        }
                        return null;
                      },
                      obscureText: !passwordIsVisible2,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Ressaisir le mot de passe: ",
                        labelText: "Ressaisir le mot de passe: ",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordIsVisible2 = !passwordIsVisible2;
                              });
                            },
                            icon: Icon(passwordIsVisible2
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurple),
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              UserModel userModel = UserModel(
                                  userName: userName.text,
                                  firstName: firstName.text,
                                  lastName: lastName.text,
                                  userType: userTypeSelected,
                                  phoneContact: phoneContact.text,
                                  password: password.text);
                              final db = DatabaseHelper();
                              db.signup(userModel).whenComplete(() {
                                if (!mounted) return;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              });
                            }
                          },
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(color: Colors.white),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Déjà un compte ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text("Connectez-vous"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
