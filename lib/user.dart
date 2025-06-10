import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/phong_add_user.dart';
import 'dart:io' show File;

void main() {
  runApp(const MyApp_Users());
}

class MyApp_Users extends StatelessWidget {
  const MyApp_Users({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserListScreen(),
    );
  }
}

// Model User được cập nhật với permissions
class User {
  String name;
  String role;
  String avatarPath;
  String? company;
  String? school;
  String? className;
  List<String>? permissions; // Thêm permissions

  User({
    required this.name,
    required this.role,
    required this.avatarPath,
    this.company,
    this.school,
    this.className,
    this.permissions,
  });
}

// Danh sách user mẫu
List<User> users = [
  User(
    name: "Nguyễn Văn A",
    role: "Admin",
    avatarPath: "images_user/men.jpg",
    school: "School A",
    className: "Class 1",
    permissions: ["manage_users", "view_all_reports"],
  ),
  User(
    name: "Trần Thị B",
    role: "Teacher",
    avatarPath: "images_user/women.jpg",
    school: "School B",
    className: "Class 2",
    permissions: ["create_report", "view_own_reports"],
  ),
  User(
    name: "Phạm Văn C",
    role: "company",
    avatarPath: "images_user/men.jpg",
    company: "Company XYZ",
    permissions: ["view_own_reports"],
  ),
];

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  TextEditingController searchController = TextEditingController();
  List<User> filteredUsers = users;

  void addUser() async {
    final newUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddUserScreen()),
    );

    if (newUser != null) {
      setState(() {
        users.add(newUser as User); // Thêm user mới vào danh sách
        filterUsers(searchController.text); // Cập nhật danh sách lọc
      });
    }
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers =
          users
              .where(
                (user) => user.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void deleteUser(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Xác nhận xóa"),
            content: const Text("Bạn có chắc chắn muốn xóa user này?"),
            actions: [
              TextButton(
                child: const Text("Xóa"),
                onPressed: () {
                  setState(() {
                    users.removeAt(index);
                    filterUsers(searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Hủy"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void editUser(int index) async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyFormEditUser(user: users[index]),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        users[index] = updatedUser;
        filterUsers(searchController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: filterUsers,
          decoration: const InputDecoration(
            hintText: "Tìm kiếm user...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.blue, // Đồng bộ màu
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailScreen(user: user),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage:
                    kIsWeb
                        ? NetworkImage(user.avatarPath)
                        : File(user.avatarPath).existsSync()
                        ? FileImage(File(user.avatarPath))
                        : NetworkImage(user.avatarPath)
                            as ImageProvider, // Xử lý cả URL và File
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.role),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () => editUser(users.indexOf(user)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(users.indexOf(user)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// MyFormEditUser cần cập nhật để hỗ trợ permissions
class MyFormEditUser extends StatefulWidget {
  final User user;

  const MyFormEditUser({required this.user, super.key});

  @override
  _MyFormEditUserState createState() => _MyFormEditUserState();
}

class _MyFormEditUserState extends State<MyFormEditUser> {
  bool isSubmitted = false;
  late String selectedRole;
  String? selectedSchool;
  String? selectedClass;
  String? selectedCompany;
  late List<String> selectedPermissions; // Cập nhật để hỗ trợ permissions
  String? _imageUrl;
  final TextEditingController _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  final List<String> roles = [
    "leader",
    "teacher",
    "principal",
    "company",
    "technician",
  ];
  final List<String> permissionsList = [
    "create_report",
    "view_own_reports",
    "manage_users",
    "view_all_reports",
  ];
  final List<String> schools = ["School A", "School B", "School C"];
  final List<String> classes = ["Class 1", "Class 2", "Class 3"];
  final List<String> companies = ["Company XYZ", "Company ABC"];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    selectedRole = widget.user.role;
    selectedSchool = widget.user.school;
    selectedClass = widget.user.className;
    selectedCompany = widget.user.company;
    _imageUrl = widget.user.avatarPath;
    _imageUrlController.text = _imageUrl ?? '';
    selectedPermissions = widget.user.permissions ?? [];
  }

  void _showImageUrlDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Enter Image URL"),
            content: TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: "Image URL",
                hintText: "https://example.com/image.jpg",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _imageUrl = _imageUrlController.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Edit User"),
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildImagePicker(),
                const SizedBox(height: 20),
                _buildTextField("Name", _nameController),
                const SizedBox(height: 20),
                _buildRolePicker(),
                const SizedBox(height: 20),
                _buildPermissionsPicker(),
                const SizedBox(height: 20),
                _buildSchoolPicker(),
                const SizedBox(height: 20),
                _buildClassPicker(),
                const SizedBox(height: 20),
                _buildCompanyPicker(),
                const SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _showImageUrlDialog,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSubmitted && _imageUrl == null
                        ? Colors.red
                        : Colors.transparent,
              ),
            ),
            child: Center(
              child: SizedBox(
                height: 120,
                width: 120,
                child:
                    _imageUrl == null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Color.fromRGBO(69, 209, 253, 1),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Enter image URL",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                        : ClipOval(
                          child: Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover,
                            height: 120,
                            width: 120,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
              ),
            ),
          ),
        ),
        if (isSubmitted && _imageUrl == null)
          _buildErrorText("Image is required!"),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator:
          (value) =>
              (value == null || value.isEmpty) ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRolePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.person,
          text: selectedRole ?? "Select Role",
          isError: isSubmitted && selectedRole == null,
          onTap: _showRolePicker,
          enabled: true,
        ),
        if (isSubmitted && selectedRole == null)
          _buildErrorText("Role is required!"),
      ],
    );
  }

  Widget _buildPermissionsPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.lock,
          text:
              selectedPermissions.isEmpty
                  ? "Select Permissions"
                  : selectedPermissions.join(", "),
          isError: isSubmitted && selectedPermissions.isEmpty,
          onTap: _showPermissionsPicker,
          enabled: true,
        ),
        if (isSubmitted && selectedPermissions.isEmpty)
          _buildErrorText("At least one permission is required!"),
      ],
    );
  }

  Widget _buildSchoolPicker() {
    final bool isEnabled = selectedRole != null && selectedRole != "company";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.school,
          text: selectedSchool ?? "Select School",
          isError:
              isSubmitted &&
              selectedRole != null &&
              selectedRole != "company" &&
              selectedSchool == null,
          onTap: isEnabled ? _showSchoolPicker : () {},
          enabled: isEnabled,
        ),
        if (isSubmitted &&
            selectedRole != null &&
            selectedRole != "company" &&
            selectedSchool == null)
          _buildErrorText("School is required!"),
      ],
    );
  }

  Widget _buildClassPicker() {
    final bool isEnabled = selectedRole != null && selectedRole != "company";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.class_,
          text: selectedClass ?? "Select Class",
          isError:
              isSubmitted &&
              selectedRole != null &&
              selectedRole != "company" &&
              selectedClass == null,
          onTap: isEnabled ? _showClassPicker : () {},
          enabled: isEnabled,
        ),
        if (isSubmitted &&
            selectedRole != null &&
            selectedRole != "company" &&
            selectedClass == null)
          _buildErrorText("Class is required!"),
      ],
    );
  }

  Widget _buildCompanyPicker() {
    final bool isEnabled = selectedRole == "company";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.business,
          text: selectedCompany ?? "Select Company",
          isError:
              isSubmitted &&
              selectedRole != null &&
              selectedRole == "company" &&
              selectedCompany == null,
          onTap: isEnabled ? _showCompanyPicker : () {},
          enabled: isEnabled,
        ),
        if (isSubmitted &&
            selectedRole != null &&
            selectedRole == "company" &&
            selectedCompany == null)
          _buildErrorText("Company is required for company role!"),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        setState(() => isSubmitted = true);
        bool isValid =
            _formKey.currentState!.validate() &&
            _imageUrl != null &&
            selectedRole != null &&
            selectedPermissions.isNotEmpty;

        if (selectedRole != null) {
          if (selectedRole == "company") {
            isValid = isValid && selectedCompany != null;
          } else {
            isValid =
                isValid && selectedSchool != null && selectedClass != null;
          }
        }

        if (isValid) {
          Navigator.pop(
            context,
            User(
              name: _nameController.text,
              role: selectedRole,
              avatarPath: _imageUrl!,
              company: selectedRole == "company" ? selectedCompany : null,
              school: selectedRole != "company" ? selectedSchool : null,
              className: selectedRole != "company" ? selectedClass : null,
              permissions: selectedPermissions,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all required fields")),
          );
        }
      },
      child: const Center(
        child: Text(
          "Save",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionBox({
    required IconData icon,
    required String text,
    required bool isError,
    required Function() onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isError ? Colors.red : Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color:
                  enabled
                      ? const Color.fromRGBO(69, 209, 253, 1)
                      : Colors.grey.withOpacity(0.5),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  text,
                  style: TextStyle(
                    color:
                        isError
                            ? Colors.red
                            : (enabled
                                ? Colors.grey
                                : Colors.grey.withOpacity(0.5)),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorText(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 12),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  void _showRolePicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: roles.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(roles[index]),
                  onTap:
                      () => setState(() {
                        selectedRole = roles[index];
                        selectedSchool = null;
                        selectedClass = null;
                        selectedCompany = null;
                        Navigator.pop(context);
                      }),
                ),
          ),
    );
  }

  void _showPermissionsPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: permissionsList.length,
                        itemBuilder:
                            (context, index) => CheckboxListTile(
                              title: Text(permissionsList[index]),
                              value: selectedPermissions.contains(
                                permissionsList[index],
                              ),
                              onChanged: (value) {
                                setModalState(() {
                                  if (value == true) {
                                    selectedPermissions.add(
                                      permissionsList[index],
                                    );
                                  } else {
                                    selectedPermissions.remove(
                                      permissionsList[index],
                                    );
                                  }
                                });
                                setState(() {});
                              },
                            ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Done"),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showSchoolPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: schools.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(schools[index]),
                  onTap:
                      () => setState(() {
                        selectedSchool = schools[index];
                        Navigator.pop(context);
                      }),
                ),
          ),
    );
  }

  void _showClassPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: classes.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(classes[index]),
                  onTap:
                      () => setState(() {
                        selectedClass = classes[index];
                        Navigator.pop(context);
                      }),
                ),
          ),
    );
  }

  void _showCompanyPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: companies.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(companies[index]),
                  onTap:
                      () => setState(() {
                        selectedCompany = companies[index];
                        Navigator.pop(context);
                      }),
                ),
          ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Information"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  kIsWeb
                      ? NetworkImage(user.avatarPath)
                      : File(user.avatarPath).existsSync()
                      ? FileImage(File(user.avatarPath))
                      : NetworkImage(user.avatarPath) as ImageProvider,
            ),
            const SizedBox(height: 20),
            Text(
              user.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              user.role,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (user.role == "company" && user.company != null)
              Text(
                "Company: ${user.company}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (user.role != "company" && user.school != null)
              Text(
                "School: ${user.school}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (user.role != "company" && user.className != null)
              Text(
                "Class: ${user.className}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (user.permissions != null && user.permissions!.isNotEmpty)
              Text(
                "Permissions: ${user.permissions!.join(", ")}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
