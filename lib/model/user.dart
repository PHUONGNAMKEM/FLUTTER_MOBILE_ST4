class UserFireStore {
  String id;
  String name;
  String role;
  String? email;
  bool? isAvailable;
  String? schoolId;
  String? classId;

  UserFireStore({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.isAvailable,
    this.schoolId,
    this.classId,
  });

  factory UserFireStore.fromFirestore(String id, Map<String, dynamic> data) {
    return UserFireStore(
      id: id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      email: data['email'],
      isAvailable: data['isAvailable'],
      schoolId: data['schoolId'],
      classId: data['classId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'isAvailable': isAvailable,
      'schoolId': schoolId,
      'classId': classId,
    };
  }
}
