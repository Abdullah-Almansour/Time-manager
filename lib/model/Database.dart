import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  static String loggedUserId() {
    User? currentFirebaseUser = FirebaseAuth.instance.currentUser;
    if (currentFirebaseUser != null)
      return currentFirebaseUser.uid;
    else
      return "logout";
  }

  static logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static CollectionReference users(){
    return FirebaseFirestore.instance.collection('user');
  }

  static CollectionReference tasks(){
    return FirebaseFirestore.instance.collection('task');
  }

}