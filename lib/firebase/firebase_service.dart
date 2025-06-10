import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_project_presentation_lastsegment/model/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // --- User Operations ---

  Stream<List<User>> getUsersStream() {
    return _firestore.collection('user').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    });
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    await _firestore.collection('user').add(userData);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('user').doc(userId).update(userData);
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('user').doc(userId).delete();
  }



  // --- School/Class Operations ---

  Stream<List<School>> getSchoolsStream() {
    return _firestore.collection('schools').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => School.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    });
  }

  Future<List<Class>> getClassesForSchool(String schoolId) async {
    final snapshot = await _firestore
        .collection('classes')
        .where('schoolId', isEqualTo: schoolId)
        .get();
        
    return snapshot.docs.map((doc) => Class.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
  }
}