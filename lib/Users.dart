import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(69, 209, 253, 1),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(69, 209, 253, 1),
        ),
      ),
      home: Users(),
    );
  }
}

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'user1',
      'name': 'Nguyễn Văn A',
      'role': 'Người quản lý',
      'permissions': ['tạo report', 'xem report'],
      'schoolId': 'school123',
      'classId': 'class456',
      'companyId': null,
    },
    {
      'id': 'user2',
      'name': 'Trần Thị B',
      'role': 'Giáo viên chủ nhiệm',
      'permissions': ['xem report', 'tạo report'],
      'schoolId': 'school123',
      'classId': 'class789',
      'companyId': null,
    },
    {
      'id': 'user3',
      'name': 'Nguyễn Văn Tèo',
      'role': 'Kỹ thuật viên',
      'permissions': ['xem report', 'chỉnh sửa report'],
      'schoolId': 'NULL',
      'classId': 'NULL',
      'companyId': null,
    },
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _classIdController = TextEditingController();
  final TextEditingController _companyIdController = TextEditingController();
  String? _selectedRole;
  List<String> _selectedPermissions = [];
  int _nextId = 3;

  final List<String> _roles = [
    'Người quản lý',
    'Kỹ thuật viên',
    'Giáo viên chủ nhiệm',
    'Lớp trưởng',
    'Lớp phó ',
  ];
  final List<String> _permissionsList = [
    'tạo report',
    'xem report',
    'chỉnh sửa report',
    'xóa report',
  ];

  void _createOrUpdateUser({String? id}) {
    final isEditing = id != null;
    if (isEditing) {
      final user = _users.firstWhere((element) => element['id'] == id);
      _nameController.text = user['name'];
      _selectedRole = user['role'];
      _selectedPermissions = List<String>.from(user['permissions']);
      _schoolIdController.text = user['schoolId'] ?? '';
      _classIdController.text = user['classId'] ?? '';
      _companyIdController.text = user['companyId'] ?? '';
    } else {
      _nameController.clear();
      _selectedRole = null;
      _selectedPermissions.clear();
      _schoolIdController.clear();
      _classIdController.clear();
      _companyIdController.clear();
    }

    showDialog(
      context: context,
      builder:
          (context) => _buildDialog(
            isEditing ? 'Chỉnh Sửa Người Dùng' : 'Thêm Người Dùng',
            () {
              if (_nameController.text.isNotEmpty && _selectedRole != null) {
                setState(() {
                  if (isEditing) {
                    final user = _users.firstWhere(
                      (element) => element['id'] == id,
                    );
                    user['name'] = _nameController.text;
                    user['role'] = _selectedRole;
                    user['permissions'] = _selectedPermissions;
                    user['schoolId'] = _schoolIdController.text;
                    user['classId'] =
                        _classIdController.text.isNotEmpty
                            ? _classIdController.text
                            : null;
                    user['companyId'] =
                        _companyIdController.text.isNotEmpty
                            ? _companyIdController.text
                            : null;
                  } else {
                    _users.add({
                      'id': 'user$_nextId',
                      'name': _nameController.text,
                      'role': _selectedRole,
                      'permissions': _selectedPermissions,
                      'schoolId': _schoolIdController.text,
                      'classId':
                          _classIdController.text.isNotEmpty
                              ? _classIdController.text
                              : null,
                      'companyId':
                          _companyIdController.text.isNotEmpty
                              ? _companyIdController.text
                              : null,
                    });
                    _nextId++;
                  }
                });
                Navigator.of(context).pop();
              }
            },
          ),
    );
  }

  void _deleteUser(String id) {
    setState(() {
      _users.removeWhere((element) => element['id'] == id);
    });
  }

  Widget _buildDialog(String title, VoidCallback onConfirm) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: _inputDecoration('Tên Người Dùng'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: _inputDecoration('Vai Trò'),
              items:
                  _roles
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _schoolIdController,
              decoration: _inputDecoration('Mã Trường'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _classIdController,
              decoration: _inputDecoration('Mã Lớp'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _companyIdController,
              decoration: _inputDecoration('Mã Công Ty'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _selectPermissions,
              child: Text(
                "Chọn Quyền (${_selectedPermissions.length})",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onConfirm,
                  child: const Text(
                    'Lưu',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectPermissions() async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder:
          (context) =>
              MultiSelectDialog(_permissionsList, _selectedPermissions),
    );
    if (selected != null) {
      setState(() => _selectedPermissions = selected);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users Management',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(
              user['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.indigo,
              ),
            ),
            subtitle: Text(
              'Vai Trò: ${user['role']}',
              style: TextStyle(color: Colors.lightBlue),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.indigo),
                  onPressed: () => _createOrUpdateUser(id: user['id']),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.redAccent,
                  onPressed: () => _deleteUser(user['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createOrUpdateUser,
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> allOptions;
  final List<String> selectedOptions;

  MultiSelectDialog(this.allOptions, this.selectedOptions);

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelectedOptions;

  @override
  void initState() {
    super.initState();
    _tempSelectedOptions = List.from(widget.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Chọn quyền"),
      content: SingleChildScrollView(
        child: ListBody(
          children:
              widget.allOptions.map((option) {
                return CheckboxListTile(
                  activeColor: const Color.fromRGBO(69, 209, 253, 1),
                  value: _tempSelectedOptions.contains(option),
                  title: Text(option),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        _tempSelectedOptions.add(option);
                      } else {
                        _tempSelectedOptions.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Hủy", style: TextStyle(color: Colors.red)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text("Xác nhận", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
          ),
          onPressed: () => Navigator.of(context).pop(_tempSelectedOptions),
        ),
      ],
    );
  }
}
