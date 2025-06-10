// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// // ĐOẠN MAIN NÀY CÓ THỂ BỎ ĐI
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const UploadImage(),
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color.fromRGBO(69, 209, 253, 1),
//         scaffoldBackgroundColor: const Color.fromRGBO(249, 250, 251, 1),
//       ),
//     );
//   }
// }

// // BỎ TỚI KHÚC NÀY THÔI, CÒN TỪ KHÚC DƯỚI TRỞ ĐI THÌ LẤY TÊN UploadImage ĐÓ BỎ VÔ VIEW NÀO MÌNH CẦN, HOẶC KHỎI CŨNG ĐƯỢC
// // MÌNH KHÔNG CẦN LÀM VẬY CŨNG ĐƯỢC, CÓ THỂ LẤY VIEW NÀY LÀM VIEW UPLOAD ẢNH RIÊNG

// class UploadImage extends StatefulWidget {
//   const UploadImage({super.key});

//   @override
//   State<UploadImage> createState() => _UploadImageState();
// }

// class _UploadImageState extends State<UploadImage> {
//   final ImagePicker _imagePicker = ImagePicker();
//   String? selectedFolder = 'images'; // Bắt đầu với thư mục images
//   bool isLoading = false;
//   List<String> imageUrls = []; // Lưu list URL của ảnh
//   List<String> folders = []; // Danh sách các thư mục con của images

//   @override
//   void initState() {
//     super.initState();
//     _loadFolders(); // Load danh sách thư mục khi khởi tạo
//     if (selectedFolder != 'images') {
//       _loadImages(
//         selectedFolder!,
//       ); // Load ảnh nếu đã chọn thư mục con - khác với thư mục images cha
//     }
//   }

//   Future<void> _loadFolders() async {
//     try {
//       final ListResult result =
//           await FirebaseStorage.instance.ref().child('images').listAll();
//       setState(() {
//         // prefixes là các thư mục con trong result (thư mục images á) ngoài ra còn có thể .items đại diện cho các file trong images nữa
//         folders = result.prefixes.map((ref) => ref.name).toList();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Failed to load folders"),
//         ),
//       );
//     }
//   }

//   Future<void> _loadImages(String folderPath) async {
//     try {
//       final ListResult result =
//           await FirebaseStorage.instance.ref().child(folderPath).listAll();
//       final List<String> urls = await Future.wait(
//         result.items.map((Reference ref) => ref.getDownloadURL()).toList(),
//       );
//       setState(() {
//         imageUrls = urls;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Failed to load images"),
//         ),
//       );
//     }
//   }

//   Future<void> pickAndUploadImage() async {
//     try {
//       XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

//       if (res != null) {
//         setState(() {
//           isLoading = true;
//         });
//         await uploadImageToFirebase(File(res.path));
//         await _loadImages(selectedFolder!); // Reload ảnh cho thư mục đã chọn
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Failed to upload"),
//         ),
//       );
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> uploadImageToFirebase(File image) async {
//     try {
//       Reference reference = FirebaseStorage.instance.ref().child(
//         "$selectedFolder/${DateTime.now().microsecondsSinceEpoch}.png",
//       );

//       await reference.putFile(image).whenComplete(() {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//             content: Text("Upload successfully"),
//           ),
//         );
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Failed to upload"),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           selectedFolder ?? 'Upload Image',
//           textAlign: TextAlign.center,
//         ),
//         backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(color: Color.fromRGBO(69, 209, 253, 1)),
//               child: Text(
//                 'Thư mục',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ExpansionTile(
//               leading: const Icon(Icons.folder),
//               title: const Text('images'),
//               children:
//                   folders.map((folder) {
//                     return ListTile(
//                       leading: const Icon(Icons.subdirectory_arrow_right),
//                       title: Text(folder),
//                       onTap: () {
//                         setState(() {
//                           selectedFolder = 'images/$folder';
//                           if (selectedFolder != 'images') {
//                             _loadImages(
//                               selectedFolder!,
//                             ); // Load ảnh cho thư mục con, duyệt qua từng thư mục, bấm vào thư mục nào, load ảnh thư mục đó
//                           }
//                         });
//                         Navigator.pop(context); // Đóng drawer sau khi chọn
//                       },
//                     );
//                   }).toList(),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // Hiển thị thư mục đã chọn
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               selectedFolder ?? 'Chọn thư mục',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           // Nút thêm ảnh khi chọn bất kỳ thư mục con
//           if (selectedFolder != null && selectedFolder != 'images')
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
//                 ),
//                 onPressed: isLoading ? null : pickAndUploadImage,
//                 child: const Text(
//                   'Thêm ảnh',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           if (isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//           // Danh sách ảnh hiện có theo thư mục
//           if (selectedFolder != null && selectedFolder != 'images')
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(8.0),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 8.0,
//                   mainAxisSpacing: 8.0,
//                 ),
//                 itemCount: imageUrls.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                         image: NetworkImage(imageUrls[index]),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const UploadImage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(69, 209, 253, 1),
        scaffoldBackgroundColor: const Color.fromRGBO(249, 250, 251, 1),
      ),
    );
  }
}

class UploadImage extends StatefulWidget {
  final Function(String?)?
  onImageSelected; // Callback để trả về imagePath cho bên devices (các collection khác) nhận được
  const UploadImage({super.key, this.onImageSelected});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final ImagePicker _imagePicker = ImagePicker();
  String? selectedFolder = 'images'; // Bắt đầu với thư mục images
  bool isLoading = false;
  List<String> imageUrls = []; // Lưu danh sách URL của các ảnh
  List<String> folders = []; // Danh sách các thư mục con của images
  String? selectedImageUrl; // Lưu URL ảnh được chọn

  @override
  void initState() {
    super.initState();
    _loadFolders(); // Load danh sách thư mục khi khởi tạo
    if (selectedFolder != 'images') {
      _loadImages(selectedFolder!); // Load ảnh nếu đã chọn thư mục con
    }
  }

  Future<void> _loadFolders() async {
    try {
      final ListResult result =
          await FirebaseStorage.instance.ref().child('images').listAll();
      setState(() {
        folders = result.prefixes.map((ref) => ref.name).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to load folders"),
        ),
      );
    }
  }

  Future<void> _loadImages(String folderPath) async {
    try {
      final ListResult result =
          await FirebaseStorage.instance.ref().child(folderPath).listAll();
      final List<String> urls = await Future.wait(
        result.items.map((Reference ref) => ref.getDownloadURL()).toList(),
      );
      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to load images"),
        ),
      );
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (res != null) {
        setState(() {
          isLoading = true;
        });
        await uploadImageToFirebase(File(res.path));
        await _loadImages(selectedFolder!); // Reload ảnh cho thư mục đã chọn
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to upload"),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    try {
      Reference reference = FirebaseStorage.instance.ref().child(
        "$selectedFolder/${DateTime.now().microsecondsSinceEpoch}.png",
      );

      await reference.putFile(image).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text("Upload successfully"),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to upload"),
        ),
      );
    }
  }

  void selectImageFromGrid(String imageUrl) {
    setState(() {
      selectedImageUrl = imageUrl;
    });
    if (widget.onImageSelected != null) {
      widget.onImageSelected!(selectedImageUrl); // Trả về đường dẫn ảnh
      Navigator.pop(context); // Quay lại view trước
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedFolder ?? 'Upload Image',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(69, 209, 253, 1)),
              child: Text(
                'Thư mục',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.folder),
              title: const Text('images'),
              children:
                  folders.map((folder) {
                    return ListTile(
                      leading: const Icon(Icons.subdirectory_arrow_right),
                      title: Text(folder),
                      onTap: () {
                        setState(() {
                          selectedFolder = 'images/$folder';
                          if (selectedFolder != 'images') {
                            _loadImages(
                              selectedFolder!,
                            ); // Load ảnh cho thư mục con, duyệt qua từng thư mục và load image cho thư mục đó
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Hiển thị thư mục đã chọn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedFolder ?? 'Chọn thư mục',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Nút thêm ảnh khi chọn bất kỳ thư mục con
          if (selectedFolder != null && selectedFolder != 'images')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
                ),
                onPressed: isLoading ? null : pickAndUploadImage,
                child: const Text(
                  'Thêm ảnh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          // Danh sách ảnh hiện có
          if (selectedFolder != null && selectedFolder != 'images')
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => selectImageFromGrid(imageUrls[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
