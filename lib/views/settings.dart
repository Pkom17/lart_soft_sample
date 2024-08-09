
import 'package:dno_app/utils/SharedPreferencesKeys.dart';
import 'package:dno_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

final formKey = GlobalKey<FormState>();
String? apiBaseUrl = "";
String? apiUserName = "";
String? apiPassword = "";
String path = "api/site/";

bool passwordIsVisible = false;

//controller
TextEditingController _apiBaseUrlController = TextEditingController();
TextEditingController _apiUserNameController = TextEditingController();
TextEditingController _apiPasswordController = TextEditingController();

class _SettingsState extends State<Settings> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    passwordIsVisible = false;
    _prefs.then((SharedPreferences prefs) {
      var url = prefs.getString(SharedPreferencesKeys.apiURL) ?? "";
      var user = prefs.getString(SharedPreferencesKeys.userLogin) ?? "";
      var pwd = prefs.getString(SharedPreferencesKeys.userPassword) ?? "";
      _apiBaseUrlController.text = url;
      _apiUserNameController.text = user;
      _apiPasswordController.text = pwd;
    });
  }

  Future<void> _defineSettings(String url, String user, String pwd) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString(SharedPreferencesKeys.apiURL, url);
      prefs.setString(SharedPreferencesKeys.userLogin, user);
      prefs.setString(SharedPreferencesKeys.userPassword, pwd);
    });

    Utils.showAlertDialog(context, "Mise à jour des paramètres effectuée");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paramètres",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.purple,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Informations sur le serveur:",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Row(
                    children: [
                      Text("URL de base de l'API"),
                    ],
                  ),
                  TextFormField(
                    controller: _apiBaseUrlController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "URL de base de l'API",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text("Nom d'utilisateur API"),
                    ],
                  ),
                  TextFormField(
                    controller: _apiUserNameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: "Nom d'utilisateur API",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Row(
                    children: [
                      Text("Mot de passe de l'utilisateur l'API"),
                    ],
                  ),
                  TextFormField(
                    controller: _apiPasswordController,
                    obscureText: !passwordIsVisible,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: const OutlineInputBorder(),
                      hintText: "Mot de passe de l'utilisateur API",
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
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.deepPurple),
                          child: TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  //add informations to sharepref
                                  _defineSettings(
                                      _apiBaseUrlController.text,
                                      _apiUserNameController.text,
                                      _apiPasswordController.text);
                                }
                              },
                              child: const Text(
                                "Enregistrer",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))),
                      const Spacer(),
                      Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.deepOrange),
                          child: TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  //clear infos
                                  _apiBaseUrlController.text = "";
                                  _apiUserNameController.text = "";
                                  _apiPasswordController.text = "";
                                }
                              },
                              child: const Text(
                                "Effacer",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
