import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/device.dart';

class ClassesScreen extends StatefulWidget {
  final String schoolId;

  const ClassesScreen({required this.schoolId});

  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final CollectionReference _classesCollection = FirebaseFirestore.instance
      .collection('classes');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  // hàm thêm mới
  Future<void> create() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return myDialogChild(
          className: "Create Class",
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

  void addItems(String className, String classId) {
    _classesCollection.add({
      'className': className,
      'classId': classId,
      'schoolId': widget.schoolId,
    });
  }

  // hàm update
  Future<void> Update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['className'];
    idController.text = documentSnapshot['classId'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return myDialogChild(
          className: "Update du lieu lai",
          condition: "Update",
          onPressed: () async {
            String className = nameController.text;
            String classId = idController.text;
            await _classesCollection.doc(documentSnapshot.id).update({
              'className': className,
              'classId': classId,
              'schoolId': widget.schoolId,
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
  Future<void> Delete(String classId) async {
    await _classesCollection.doc(classId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Delete successfully"),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  Dialog myDialogChild({
    required String className,
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
                className,
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
              labelText: "Enter the name of Class",
              hintText: "eg. Khoa 13 Dai hoc tin hoc 02",
            ),
          ),
          TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: "Enter the Class Id",
              hintText: "eg. 13DHTH02",
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: onPressed, child: Text(condition)),
          SizedBox(height: 10),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh Sách Lớp - ${widget.schoolId}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream:
            _classesCollection
                .where('schoolId', isEqualTo: widget.schoolId)
                .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final classes = snapshot.data!.docs;

          return classes.isEmpty
              ? const Center(
                child: Text(
                  'Không có lớp học nào',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final classData = classes[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7), // Độ trong suốt
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
                                  (context) => DeviceListScreen(
                                    classId: classData['classId'],
                                  ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 120, // Giống mẫu
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      classData['className'],
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
                                      classData['classId'],
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
                                        Update(classData);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        Delete(classData.id);
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
