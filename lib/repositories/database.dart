import 'package:zeroday/models/interns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference internCollection =FirebaseFirestore.instance.collection('intern');

  // Future updateUserData() async{
  //   return await internCollection.doc(uid).set({
  //     'count':
  //   })
  // }
}

