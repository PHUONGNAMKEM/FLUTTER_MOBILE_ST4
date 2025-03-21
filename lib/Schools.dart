import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: SchoolsScreen(),
    );
  }
}

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});
  @override
  _SchoolsScreenState createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  final List<Map<String, dynamic>> _schools = [
    {
      'id': 'school123',
      'name': 'Trường Nguyễn Văn Phú',
      'principalId': 'user123',
      'classes': [
        {
          'id': 'NVP5A1',
          'name': 'Lớp 5A1',
          'teacherId': 'user777',
          'leaders': ['user789', 'user101'],
          'devices': [
            {'id': 'device1', 'name': 'Máy lạnh', 'status': 'Đang hỏng'},
            {'id': 'device2', 'name': 'Máy chiếu', 'status': 'Hoạt động'},
          ],
        },
        {
          'id': 'NVP5A2',
          'name': 'Lớp 5A2',
          'teacherId': 'user888',
          'leaders': ['user987', 'user102'],
          'devices': [
            {'id': 'device1', 'name': 'Máy lạnh', 'status': 'Đang hỏng'},
            {'id': 'device2', 'name': 'Máy chiếu', 'status': 'Hoạt động'},
          ],
        },
      ],
    },
    {
      'id': 'school456',
      'name': 'Trường Võ Văn Tần',
      'principalId': 'user987',
      'classes': [],
    },
  ];

  final TextEditingController _nameController = TextEditingController();
  int _nextSchoolId = 3;

  void _addOrEditSchool({String? id}) {
    final isEditing = id != null;
    if (isEditing) {
      final school = _schools.firstWhere((s) => s['id'] == id);
      _nameController.text = school['name'];
    } else {
      _nameController.clear();
    }

    showDialog(
      context: context,
      builder:
          (context) => _buildSchoolDialog(
            isEditing ? 'Chỉnh Sửa Trường' : 'Thêm Trường',
            () {
              if (_nameController.text.isNotEmpty) {
                setState(() {
                  if (isEditing) {
                    final school = _schools.firstWhere((s) => s['id'] == id);
                    school['name'] = _nameController.text;
                  } else {
                    _schools.add({
                      'id': 'school$_nextSchoolId',
                      'name': _nameController.text,
                      'principalId': '',
                      'classes': [],
                    });
                    _nextSchoolId++;
                  }
                });
                Navigator.of(context).pop();
              }
            },
          ),
    );
  }

  void _deleteSchool(String id) {
    setState(() {
      _schools.removeWhere((s) => s['id'] == id);
    });
  }

  Widget _buildSchoolDialog(String title, VoidCallback onConfirm) {
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
              decoration: _inputDecoration('Tên Trường'),
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
          'Schools Management',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body:
          _schools.isEmpty
              ? const Center(
                child: Text('Không có dữ liệu', style: TextStyle(fontSize: 18)),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _schools.length,
                itemBuilder: (context, index) {
                  final school = _schools[index];
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        school['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                            onPressed: () => _addOrEditSchool(id: school['id']),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _deleteSchool(school['id']),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassesScreen(school: school),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditSchool,
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClassesScreen extends StatelessWidget {
  final Map<String, dynamic> school;

  ClassesScreen({required this.school});

  @override
  Widget build(BuildContext context) {
    final classes = school['classes'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Lớp', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          classes.isEmpty
              ? const Center(
                child: Text('Không có lớp học', style: TextStyle(fontSize: 18)),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final classData = classes[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        classData['name'],
                        style: TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 23,
                        ),
                      ),
                      subtitle: Text(
                        'Giáo viên chủ nhiệm: ${classData['teacherId']}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DevicesScreen(classData: classData),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

class DevicesScreen extends StatelessWidget {
  final Map<String, dynamic> classData;

  DevicesScreen({required this.classData});

  @override
  Widget build(BuildContext context) {
    final devices = classData['devices'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thiết Bị - ${classData['name']}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          devices.isEmpty
              ? const Center(
                child: Text(
                  'Không có thiết bị',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return ListTile(
                    title: Text(
                      device['name'],
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontSize: 23,
                      ),
                    ),
                    subtitle: Text(
                      'Trạng thái: ${device['status']}',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  );
                },
              ),
    );
  }
}
