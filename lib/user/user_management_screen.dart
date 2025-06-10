import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/model/user_model.dart';
import 'package:flutter_project_presentation_lastsegment/firebase/firebase_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _searchQuery = '';

  void _navigateToForm({User? user}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserFormScreen(user: user)),
    );
  }

  void _deleteUser(String userId) {
    // Capture ScaffoldMessenger using the context of _UserListScreenState, which should remain valid.
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa user này?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); 
              await _firebaseService.deleteUser(userId);
              if (mounted) { 
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("User đã được xóa.")),
                );
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            child: const Text("Hủy"),
            onPressed: () => Navigator.pop(dialogContext),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: "Tìm kiếm user...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<User>>(
        stream: _firebaseService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Đã có lỗi xảy ra: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có user nào."));
          }

          final allUsers = snapshot.data!;
          final query = _searchQuery.toLowerCase().trim(); 
          final filteredUsers = query.isEmpty
              ? allUsers
              : allUsers.where((user) {
                  final nameMatches = user.name.toLowerCase().contains(query);
                  final emailMatches = user.email.toLowerCase().contains(query);
                  
                  return nameMatches || emailMatches;
                }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index]; 
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  onTap: () {
                  },
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 40,
                  ),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user.role),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _navigateToForm(user: user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Màn hình Form để Thêm/Sửa User
class UserFormScreen extends StatefulWidget {
  final User? user; // Null nếu là "Add", có giá trị nếu là "Edit"

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  // Bien state
  bool _isEditMode = false;
  String? _selectedRole;
  String? _selectedSchoolId;
  String? _selectedClassId;
  bool _isAvailable = true;
  bool _isLoading = false;
  List<Class> _availableClasses = [];
  bool _isClassesLoading = false;

  final List<String> _roles = ["leader", "teacher", "principal", "company", "technician", "admin"];
  final List<String> _schoolRequiredRoles = ["leader", "principal", "teacher"];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.user != null;
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    if (_isEditMode) {
      final user = widget.user!;
      _selectedRole = user.role;
      _selectedSchoolId = user.schoolId;
      _selectedClassId = user.classId;
      _isAvailable = user.isAvailable;
  
      if (_selectedSchoolId != null) {
        _fetchClassesForSchool(_selectedSchoolId!);
      }
    }
  }

  Future<void> _fetchClassesForSchool(String schoolId) async {
    setState(() {
      _isClassesLoading = true;
      _availableClasses = [];
      _selectedClassId = null;
    });
    
    print("--- debug class ở đây: $schoolId ---");

    try {
      final classes = await _firebaseService.getClassesForSchool(schoolId);

      //debug
      print(">>> ĐÃ TÌM THẤY: ${classes.length} LỚP");
      for (var c in classes) {
        print("  - Lớp: ${c.name}, ID: ${c.classId}");
      }

      setState(() {
        _availableClasses = classes;
      });
    } catch (e) {
      print("Error fetching classes: $e");
    } finally {
      setState(() {
        _isClassesLoading = false;
      });
    }
  }
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ các trường bắt buộc.")),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'role': _selectedRole,
      'schoolId': _schoolRequiredRoles.contains(_selectedRole) ? _selectedSchoolId : null,
      'classId': _schoolRequiredRoles.contains(_selectedRole) ? _selectedClassId : null,
      'isAvailable': _isAvailable,
    };

      if (_isEditMode) {
        await _firebaseService.updateUser(widget.user!.id!, userData);
      } else {
        await _firebaseService.addUser(userData);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User đã được ${_isEditMode ? 'cập nhật' : 'thêm'} thành công!")),
        );
        Navigator.pop(context);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã có lỗi xảy ra: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? "Edit User" : "Add User"),
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(_nameController, "Họ tên"),
                      const SizedBox(height: 20),
                      _buildTextField(_emailController, "Email"),
                      const SizedBox(height: 20),
                      _buildRolePicker(),
                      const SizedBox(height: 20),
                      _buildSchoolPicker(),
                      const SizedBox(height: 20),
                      _buildClassPicker(),
                      const SizedBox(height: 20),
                      _buildAvailabilitySwitch(),
                      const SizedBox(height: 30),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // --- BUILD WIDGETS ---
  

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      validator: (value) => (value == null || value.isEmpty) ? '$label không được để trống' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildRolePicker() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      hint: const Text("Select Role"),
      decoration: _inputDecoration(),
      items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
      onChanged: (value) => setState(() {
        _selectedRole = value;
        _selectedSchoolId = null;
        _selectedClassId = null;
      }),
      validator: (value) => value == null ? 'Vui lòng chọn vai trò' : null,
    );
  }

  Widget _buildSchoolPicker() {
    bool isEnabled = _selectedRole != null && _schoolRequiredRoles.contains(_selectedRole!);
    return StreamBuilder<List<School>>(
    stream: _firebaseService.getSchoolsStream(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return isEnabled ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
      }
      final schools = snapshot.data!;
      return DropdownButtonFormField<String>(
        isExpanded: true,
        value: _selectedSchoolId,
        hint: const Text("Select School"),
        disabledHint: const Text("Không áp dụng cho vai trò này"),
        decoration: _inputDecoration(),
        items: schools.map((school) {
          return DropdownMenuItem(
            value: school.schoolId,
            child: Text(school.name),
          );
        }).toList(),
        onChanged: isEnabled
            ? (value) {
                if (value != null && value != _selectedSchoolId) {
                  _fetchClassesForSchool(value);
                }
                setState(() {
                  _selectedSchoolId = value;
                });
              }
            : null,
        validator: (value) => isEnabled && value == null ? 'Vui lòng chọn trường' : null,
      );
      },
    );
  }

  Widget _buildClassPicker() {
    bool isEnabled = _selectedRole != null &&
      _schoolRequiredRoles.contains(_selectedRole!) &&
      _selectedSchoolId != null &&
      !_isClassesLoading;

    return DropdownButtonFormField<String>(
    value: _selectedClassId,
    hint: Text(_isClassesLoading
        ? "Đang tải lớp học..."
        : _selectedSchoolId == null
            ? "Vui lòng chọn trường trước"
            : "Select Class"),
    // Thêm thuộc tính disabledHint
    disabledHint: _selectedRole != null && !_schoolRequiredRoles.contains(_selectedRole!)
        ? const Text("Không áp dụng cho vai trò này")
        : (_isClassesLoading
            ? const Center(child: CircularProgressIndicator())
            : const Text("Vui lòng chọn trường trước")),
    decoration: _inputDecoration(),
    items: _availableClasses.map((c) {
      return DropdownMenuItem(
        value: c.classId,
        child: Text(c.name),
      );
    }).toList(),
    onChanged: isEnabled ? (value) => setState(() => _selectedClassId = value) : null,
    validator: (value) {
      if (isEnabled && value == null) {
        return 'Vui lòng chọn lớp';
      }
      return null;
      },
    );
  }

  Widget _buildAvailabilitySwitch() {
    return SwitchListTile(
      title: const Text("Cho phép hoạt động?"),
      value: _isAvailable,
      onChanged: (value) => setState(() => _isAvailable = value),
      activeColor: Colors.blue,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: _submitForm,
      child: Text(
        _isEditMode ? "Save Changes" : "Add User",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }
}