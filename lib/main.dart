import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:simplenotes/splash/splashscreen.dart';
import 'package:simplenotes/views/AuthenticationView.dart';
import 'package:simplenotes/views/AddNewNote.dart';
import 'package:simplenotes/custom/BackgroundVideo.dart';
import 'package:simplenotes/views/EditNote.dart';
import 'package:simplenotes/views/LoadingView.dart';

import 'package:simplenotes/views/LoginView.dart';
import 'package:simplenotes/views/notesview.dart';
import 'package:simplenotes/views/RegisterView.dart';
import 'package:simplenotes/views/settingsview.dart';
import 'package:simplenotes/views/TrashView.dart';
import 'package:simplenotes/views/VerifyEmailView.dart';
import 'package:simplenotes/views/viewnote.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
    ),
    home: const Splash(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/verifyemail/': (context) => const VerifyEmailView(),
      '/notes/': (context) => const NotesView(),
      '/addnote/': (context) => const AddNewNote(),
      '/viewnote/': (context) => const ViewNote(),
      '/editnote/': (context) => const EditNote(),
      '/trash/': (context) => const TrashView(),
      '/settings/': (context) => const SettingsView(),
      '/auth/': (context) => const AuthView(),
      '/splash/': (context) => const Splash(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static late bool is_auth_enabled = false;
  static late bool comes_from_auth_view = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FutureBuilderFunctionCall(),
        builder: (context, snapshot) {
          if (is_auth_enabled && !comes_from_auth_view) {
            return const AuthView();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user?.emailVerified == true) {
                return const NotesView();
              } else {
                if (user != null) {
                  // Display verification page here
                  return const VerifyEmailView();
                } else {
                  return const LoginView();
                }
              }
            // return const LoginView();
            default:
              return const LoadingView();
          }
        });
  }
}

Future<FirebaseApp> FutureBuilderFunctionCall() async {
  String localAuthState = await SettingsView.getAuthState() ?? "";
  if (localAuthState != "") {
    if (localAuthState == 'true') {
      HomePage.is_auth_enabled = true;
    } else if (localAuthState == 'false') {
      HomePage.is_auth_enabled = false;
    }
  }
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
