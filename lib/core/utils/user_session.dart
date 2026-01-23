import 'package:firebase_auth/firebase_auth.dart';

class UserSession {
  static String get uid =>
  FirebaseAuth.instance.currentUser!.uid;
}