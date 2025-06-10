import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  bool _isStudent = false;
  bool _studentModeEnabled = false;
  String? _selectedSchoolId;
  String? _selectedSchoolName;
  String? _selectedClassId;
  String? _selectedClassName;

  List<Map<String, dynamic>> _schools = [];
  List<Map<String, dynamic>> _classes = [];

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadSchools() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('schools').get();
    setState(() {
      _schools =
          snapshot.docs
              .map((doc) => {'id': doc['schoolId'], 'name': doc['schoolName']})
              .toList();
    });
  }

  Future<void> _loadClasses(String schoolId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('classes')
            .where('schoolId', isEqualTo: schoolId)
            .get();

    setState(() {
      _classes =
          snapshot.docs
              .map((doc) => {'id': doc['classId'], 'name': doc['className']})
              .toList();
    });
  }

  void _signUp() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Mật khẩu xác nhận không khớp');
      return;
    }

    if (_studentModeEnabled) {
      if (_selectedSchoolId == null || _selectedClassId == null) {
        _showMessage('Vui lòng chọn trường và lớp học');
        return;
      }
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .set({
            'name': username,
            'email': email,
            'role': _isStudent ? 'teacher' : 'technician',
            'schoolId': _isStudent ? _selectedSchoolId : null,
            'classId': _isStudent ? _selectedClassId : null,
            'isAvailable':
                !_isStudent, // nếu là giáo viên thì ko cần isAvailable
          });

      _showMessage('Đăng ký thành công!');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Đăng ký thất bại';
      if (e.code == 'email-already-in-use') {
        message = 'Email đã được đăng ký';
      } else if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu (ít nhất 6 ký tự)';
      }
      _showMessage(message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _updateStudentStatus() {
    if (_studentModeEnabled &&
        _selectedSchoolId != null &&
        _selectedClassId != null) {
      _isStudent = true;
    } else {
      _isStudent = false;
    }
    setState(() {}); // cập nhật UI
  }

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/computer1.png', width: 150, height: 150),
              const SizedBox(height: 8),
              const Text(
                'Hệ Thống Quản Lý Thiết Bị Trường Học',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: _isObscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscurePassword = !_isObscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Confirm Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirmPassword = !_isObscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text("Are you a student?"),
                value: _studentModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _studentModeEnabled = value!;
                    _selectedSchoolId = null;
                    _selectedClassId = null;
                    _classes = [];
                    _isStudent = false; // reset lại
                  });
                },
              ),

              if (_studentModeEnabled)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Select School',
                        ),
                        value: _selectedSchoolId,
                        items:
                            _schools.map((school) {
                              return DropdownMenuItem<String>(
                                value: school['id'],
                                child: Text(school['name']),
                              );
                            }).toList(),
                        onChanged: (value) async {
                          _selectedSchoolId = value;
                          _selectedClassId = null;
                          _selectedSchoolName =
                              _schools.firstWhere(
                                (s) => s['id'] == value,
                              )['name'];
                          await _loadClasses(value!);
                          _updateStudentStatus();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Select Class',
                        ),
                        value: _selectedClassId,
                        items:
                            _classes.map((classItem) {
                              return DropdownMenuItem<String>(
                                value: classItem['id'],
                                child: Text(classItem['name']),
                              );
                            }).toList(),
                        onChanged: (value) {
                          _selectedClassId = value;
                          _selectedClassName =
                              _classes.firstWhere(
                                (c) => c['id'] == value,
                              )['name'];
                          _updateStudentStatus();
                        },
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
                ),
                onPressed: _signUp,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              const Text('or continue with'),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    label: const Text('Google'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.apple,
                      color: Colors.black,
                    ),
                    label: const Text('Apple'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
