import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;
import 'dart:io' show File;
import 'package:flutter_project_presentation_lastsegment/user.dart'; // Thêm import này

void main() {
  runApp(MyApp_Users());
}

class MyFormEditUser extends StatelessWidget {
  final User user; // Bây giờ User sẽ được nhận diện

  const MyFormEditUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AddUserScreen_edit(user: user);
  }
}

class AddUserScreen_edit extends StatefulWidget {
  final User user;

  const AddUserScreen_edit({super.key, required this.user});

  @override
  State<AddUserScreen_edit> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen_edit> {
  bool isSubmitted = false;
  String? selectedRole;
  String? selectedSchool;
  String? selectedClass;
  String? selectedCompany;
  List<String> selectedPermissions = [];
  File? _selectedImage;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

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
    // Khởi tạo giá trị ban đầu từ user
    _nameController.text = widget.user.name;
    selectedRole = widget.user.role;
    _imageUrl = widget.user.avatarPath;
    selectedSchool = widget.user.school;
    selectedClass = widget.user.className;
    selectedCompany = widget.user.company;
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      _showImageUrlDialog();
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
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
      appBar: _buildAppBar(),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "Edit User",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSubmitted && _selectedImage == null && _imageUrl == null
                        ? Colors.red
                        : Colors.transparent,
              ),
            ),
            child: Center(
              child: SizedBox(
                height: 120,
                width: 120,
                child:
                    kIsWeb
                        ? (_imageUrl == null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: const Color.fromRGBO(69, 209, 253, 1),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Enter image URL",
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
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
                                    (context, error, stackTrace) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Failed to load image",
                                          style: TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                              ),
                            ))
                        : (_selectedImage == null
                            ? (_imageUrl != null
                                ? ClipOval(
                                  child: Image.network(
                                    _imageUrl!,
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 120,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: const Color.fromRGBO(
                                        69,
                                        209,
                                        253,
                                        1,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Tap to select an image",
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ))
                            : ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              ),
                            )),
              ),
            ),
          ),
        ),
        if (isSubmitted && _selectedImage == null && _imageUrl == null)
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
              selectedSchool == null &&
              selectedRole != "company",
          onTap: isEnabled ? _showSchoolPicker : () {},
          enabled: isEnabled,
        ),
        if (isSubmitted && selectedSchool == null && selectedRole != "company")
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
          text: selectedClass ?? "Select Class (Optional)",
          isError: false,
          onTap: isEnabled ? _showClassPicker : () {},
          enabled: isEnabled,
        ),
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
          text: selectedCompany ?? "Select Company (Optional)",
          isError:
              isSubmitted &&
              selectedCompany == null &&
              selectedRole == "company",
          onTap: isEnabled ? _showCompanyPicker : () {},
          enabled: isEnabled,
        ),
        if (isSubmitted && selectedCompany == null && selectedRole == "company")
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
        if (_formKey.currentState!.validate() &&
            (_selectedImage != null || _imageUrl != null) &&
            selectedRole != null &&
            selectedPermissions.isNotEmpty &&
            (selectedRole == "company"
                ? selectedCompany != null
                : selectedSchool != null)) {
          // Tạo đối tượng User đã chỉnh sửa
          User updatedUser = User(
            name: _nameController.text,
            role: selectedRole!,
            avatarPath:
                kIsWeb
                    ? _imageUrl!
                    : (_selectedImage != null
                        ? _selectedImage!.path
                        : _imageUrl!),
            company: selectedRole == "company" ? selectedCompany : null,
            school: selectedRole != "company" ? selectedSchool : null,
            className: selectedRole != "company" ? selectedClass : null,
          );

          // Trả về đối tượng User đã chỉnh sửa và thoát màn hình
          Navigator.pop(context, updatedUser);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Edit user successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all required fields")),
          );
        }
      },
      child: const Center(
        child: Text(
          "Edit User",
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
