import 'package:dno_app/views/rider_menu.dart';
import 'package:dno_app/views/synchronization.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/authentication/login.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/views/home.dart';
import 'package:dno_app/views/lab_menu.dart';
import 'package:dno_app/views/settings.dart';

class NavDrawer extends StatelessWidget {
  final UserModel? profile;

  const NavDrawer({super.key, this.profile});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width * 0.50,
      child: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 105, 8, 124),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  '${profile?.firstName ?? ""}  ${profile?.lastName ?? ""}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                accountEmail: Text(profile?.userName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset('images/avatar.jpg'),
                  ),
                ),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 142, 17, 153),
                    image: DecorationImage(
                        image: AssetImage('images/back.jpg'),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                title: const Text('Accueil'),
                textColor: Colors.white,
                leading: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(profile: profile))),
              ),
              if (profile?.userType == 'CONVOYEUR')
                ListTile(
                  title: const Text('Convoyeur'),
                  textColor: Colors.white,
                  leading: const Icon(
                    Icons.delivery_dining,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RiderMenu(profile: profile))),
                ),
              if (profile?.userType == 'BIOLOGISTE')
                ListTile(
                  title: const Text('Laboratoire'),
                  textColor: Colors.white,
                  leading: const Icon(
                    Icons.science,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LabMenu(profile: profile))),
                ),
              const Divider(),
              ListTile(
                title: const Text('Synchroniser'),
                textColor: Colors.white,
                leading: const Icon(
                  Icons.sync,
                  color: Colors.white,
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Synchronization())),
              ),
              ListTile(
                title: const Text('Paramètres'),
                textColor: Colors.white,
                leading: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings())),
              ),
              ListTile(
                title: const Text('A propos'),
                textColor: Colors.white,
                leading: const Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(profile: profile))),
              ),
              ListTile(
                title: const Text('Se deconnecter'),
                textColor: Colors.white,
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
