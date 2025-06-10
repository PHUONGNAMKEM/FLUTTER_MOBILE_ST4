// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'School Management',
//       theme: ThemeData(
//         primaryColor: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//       ),
//       home: SchoolsScreen(),
//     );
//   }
// }

// class SchoolsScreen extends StatefulWidget {
//   const SchoolsScreen({super.key});
//   @override
//   _SchoolsScreenState createState() => _SchoolsScreenState();
// }

// class _SchoolsScreenState extends State<SchoolsScreen> {
//   final List<Map<String, dynamic>> _schools = [
//     {
//       'id': 'school123',
//       'name': 'Trường Nguyễn Văn Phú',
//       'principalId': 'user123',
//       'classes': [
//         {
//           'id': 'NVP5A1',
//           'name': 'Lớp 5A1',
//           'teacherId': 'user777',
//           'leaders': ['user789', 'user101'],
//           'devices': [
//             {'id': 'device1', 'name': 'Máy lạnh', 'status': 'Đang hỏng'},
//             {'id': 'device2', 'name': 'Máy chiếu', 'status': 'Hoạt động'},
//           ],
//         },
//         {
//           'id': 'NVP5A2',
//           'name': 'Lớp 5A2',
//           'teacherId': 'user888',
//           'leaders': ['user987', 'user102'],
//           'devices': [
//             {'id': 'device1', 'name': 'Máy lạnh', 'status': 'Đang hỏng'},
//             {'id': 'device2', 'name': 'Máy chiếu', 'status': 'Hoạt động'},
//           ],
//         },
//       ],
//     },
//     {
//       'id': 'school456',
//       'name': 'Trường Võ Văn Tần',
//       'principalId': 'user987',
//       'classes': [],
//     },
//   ];

//   final TextEditingController _nameController = TextEditingController();
//   int _nextSchoolId = 3;

//   void _addOrEditSchool({String? id}) {
//     final isEditing = id != null;
//     if (isEditing) {
//       final school = _schools.firstWhere((s) => s['id'] == id);
//       _nameController.text = school['name'];
//     } else {
//       _nameController.clear();
//     }

//     showDialog(
//       context: context,
//       builder:
//           (context) => _buildSchoolDialog(
//             isEditing ? 'Chỉnh Sửa Trường' : 'Thêm Trường',
//             () {
//               if (_nameController.text.isNotEmpty) {
//                 setState(() {
//                   if (isEditing) {
//                     final school = _schools.firstWhere((s) => s['id'] == id);
//                     school['name'] = _nameController.text;
//                   } else {
//                     _schools.add({
//                       'id': 'school$_nextSchoolId',
//                       'name': _nameController.text,
//                       'principalId': '',
//                       'classes': [],
//                     });
//                     _nextSchoolId++;
//                   }
//                 });
//                 Navigator.of(context).pop();
//               }
//             },
//           ),
//     );
//   }

//   void _deleteSchool(String id) {
//     setState(() {
//       _schools.removeWhere((s) => s['id'] == id);
//     });
//   }

//   Widget _buildSchoolDialog(String title, VoidCallback onConfirm) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _nameController,
//               decoration: _inputDecoration('Tên Trường'),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 OutlinedButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Hủy', style: TextStyle(color: Colors.red)),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: onConfirm,
//                   child: const Text(
//                     'Lưu',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: const Text(
//         //   'Schools Management',
//         //   style: TextStyle(color: Colors.white),
//         // ),
//         // centerTitle: true,
//         // backgroundColor: Colors.blue,
//       ),
//       body:
//           _schools.isEmpty
//               ? const Center(
//                 child: Text('Không có dữ liệu', style: TextStyle(fontSize: 18)),
//               )
//               : ListView.builder(
//                 padding: const EdgeInsets.all(8),
//                 itemCount: _schools.length,
//                 itemBuilder: (context, index) {
//                   final school = _schools[index];
//                   return Card(
//                     color: Colors.white,
//                     elevation: 3,
//                     margin: const EdgeInsets.symmetric(
//                       vertical: 6,
//                       horizontal: 8,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         school['name'],
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.indigoAccent,
//                         ),
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.indigo),
//                             onPressed: () => _addOrEditSchool(id: school['id']),
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.delete,
//                               color: Colors.redAccent,
//                             ),
//                             onPressed: () => _deleteSchool(school['id']),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ClassesScreen(school: school),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addOrEditSchool,
//         backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class ClassesScreen extends StatelessWidget {
//   final Map<String, dynamic> school;

//   ClassesScreen({required this.school});

//   @override
//   Widget build(BuildContext context) {
//     final classes = school['classes'] as List<dynamic>;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh Sách Lớp', style: TextStyle(color: Colors.white)),
//         backgroundColor: Color.fromRGBO(69, 209, 253, 1),
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body:
//           classes.isEmpty
//               ? const Center(
//                 child: Text('Không có lớp học', style: TextStyle(fontSize: 18)),
//               )
//               : ListView.builder(
//                 padding: const EdgeInsets.all(8),
//                 itemCount: classes.length,
//                 itemBuilder: (context, index) {
//                   final classData = classes[index];
//                   return Card(
//                     color: Colors.white,
//                     child: ListTile(
//                       title: Text(
//                         classData['name'],
//                         style: TextStyle(
//                           color: Colors.indigoAccent,
//                           fontSize: 23,
//                         ),
//                       ),
//                       subtitle: Text(
//                         'Giáo viên chủ nhiệm: ${classData['teacherId']}',
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) =>
//                                     DevicesScreen(classData: classData),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

// class DevicesScreen extends StatelessWidget {
//   final Map<String, dynamic> classData;

//   DevicesScreen({required this.classData});

//   @override
//   Widget build(BuildContext context) {
//     final devices = classData['devices'] as List<dynamic>;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Thiết Bị - ${classData['name']}',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color.fromRGBO(69, 209, 253, 1),
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body:
//           devices.isEmpty
//               ? const Center(
//                 child: Text(
//                   'Không có thiết bị',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               )
//               : ListView.builder(
//                 itemCount: devices.length,
//                 itemBuilder: (context, index) {
//                   final device = devices[index];
//                   return ListTile(
//                     title: Text(
//                       device['name'],
//                       style: TextStyle(
//                         color: Colors.indigoAccent,
//                         fontSize: 23,
//                       ),
//                     ),
//                     subtitle: Text(
//                       'Trạng thái: ${device['status']}',
//                       style: TextStyle(color: Colors.black, fontSize: 16),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/ClassesScreen.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final CollectionReference myItems = FirebaseFirestore.instance.collection(
    "schools",
  );

  // hàm thêm mới
  Future<void> create() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return myDialogChild(
          schoolName: "Create School",
          condition: "Create",
          onPressed: () {
            String name = nameController.text;
            String id = idController.text;
            addItems(name, id);

            setState(() {
              nameController.clear();
              idController.clear();
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void addItems(String schoolName, String schoolId) {
    myItems.add({'schoolName': schoolName, 'schoolId': schoolId});
  }

  // hàm update
  Future<void> Update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['schoolName'];
    idController.text = documentSnapshot['schoolId'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return myDialogChild(
          schoolName: "Update du lieu lai",
          condition: "Update",
          onPressed: () async {
            String schoolName = nameController.text;
            String schoolId = idController.text;
            await myItems.doc(documentSnapshot.id).update({
              'schoolName': schoolName,
              'schoolId': schoolId,
            });

            setState(() {
              nameController.clear();
              idController.clear();
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // hàm delete
  Future<void> Delete(String schoolId) async {
    await myItems.doc(schoolId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Delete successfully"),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  Dialog myDialogChild({
    required String schoolName,
    required String condition,
    required VoidCallback onPressed,
  }) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schoolName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),

          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Enter the name of School",
              hintText: "eg. Ho Chi Minh City University of Industry and Trade",
            ),
          ),
          TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: "Enter the School Id",
              hintText: "eg. DHCT",
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: onPressed, child: Text(condition)),
          SizedBox(height: 10),
        ],
      ),
    ),
  );

  String searchText = "";
  void onSearchChange(String value) {
    setState(() {
      searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: myItems.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<DocumentSnapshot> items =
                streamSnapshot.data!.docs
                    .where(
                      (doc) => doc['schoolName'].toLowerCase().contains(
                        searchText.toLowerCase(),
                      ),
                    )
                    .toList();
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = items[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.7,
                      ), // Độ trong suốt (0.0 - 1.0)
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ClassesScreen(
                                  schoolId: documentSnapshot['schoolId'],
                                ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    documentSnapshot['schoolName'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    documentSnapshot['schoolId'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color.fromRGBO(69, 209, 253, 1),
                                    ),
                                    onPressed: () {
                                      Update(documentSnapshot);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      Delete(documentSnapshot.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: create,
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
