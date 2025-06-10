import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  String id; // document id
  String classId; // field in document
  String className;
  String schoolId;

  ClassModel({
    required this.id,
    required this.classId,
    required this.className,
    required this.schoolId,
  });

  factory ClassModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClassModel(
      id: doc.id,
      classId: data['classId'],
      className: data['className'],
      schoolId: data['schoolId'],
    );
  }
}
