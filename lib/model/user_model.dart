import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  String name;
  String email;
  String role;
  String? schoolId;
  String? classId;

  bool isAvailable;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.schoolId,
    this.classId,
    this.isAvailable = true,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      schoolId: data['schoolId'], 
      classId: data['classId'],
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'schoolId': schoolId,
      'classId': classId,
      'isAvailable': isAvailable,
    };
  }
}

class School {
  final String docId;
  final String schoolId;
  final String name;

  School({required this.docId, required this.schoolId, required this.name});

  factory School.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return School(docId: doc.id, 
    name: data['schoolName'],
    schoolId: data ['schoolId']
    ?? 'Unknown School');
  }
}

class Class {
  final String docId;
  final String classId;
  final String schoolId;
  final String name;

  Class({required this.docId, required this.classId, required this.schoolId, required this.name});

  factory Class.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Class(
      docId: doc.id,
      classId: data['classId'] ?? '', 
      schoolId: data['schoolId'] ?? '',
      name: data['className'] ?? 'Unknown Class',
    );
  }
}