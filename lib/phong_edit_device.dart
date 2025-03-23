import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/device.dart'; // Import Device từ device.dart
import 'dart:io' show File;
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;

void main() {
  runApp(const MyApp_EditDevice());
}

class MyApp_EditDevice extends StatelessWidget {
  const MyApp_EditDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditDeviceScreen(
        device: devices[0], // Sử dụng devices từ device.dart
      ),
    );
  }
}

// EditDeviceScreen
class EditDeviceScreen extends StatefulWidget {
  final Device device;

  const EditDeviceScreen({required this.device, super.key});

  @override
  _EditDeviceScreenState createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  bool isSubmitted = false;
  late String selectedType;
  late String selectedStatus;
  String? selectedAssignedTo;
  File? _imageFile;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final ImagePicker _picker = ImagePicker();

  final List<String> deviceTypes = ["Máy chiếu", "Máy in", "Máy tính", "Khác"];
  final List<String> statuses = ["Sẵn sàng", "Đang sử dụng", "Bảo trì"];
  final List<String> schools = ["school123", "school456", "school789"];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    selectedType = widget.device.type;
    selectedStatus = widget.device.status;
    selectedAssignedTo = widget.device.assignedTo;
    _imagePath = widget.device.imagePath;
    if (_imagePath != null && !kIsWeb) {
      _imageFile = File(_imagePath!);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Chọn nguồn ảnh"),
            actions: [
              TextButton(
                child: const Text("Thư viện"),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              TextButton(
                child: const Text("Máy ảnh"),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
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
        title: const Text("Edit Device"),
        backgroundColor: Colors.blue,
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
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : (_imagePath != null
                                  ? (kIsWeb
                                      ? NetworkImage(_imagePath!)
                                          as ImageProvider
                                      : FileImage(File(_imagePath!))
                                          as ImageProvider)
                                  : null),
                      child:
                          _imageFile == null && _imagePath == null
                              ? const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField("Device Name", _nameController),
                const SizedBox(height: 20),
                _buildTypePicker(),
                const SizedBox(height: 20),
                _buildStatusPicker(),
                const SizedBox(height: 20),
                _buildAssignedToPicker(),
                const SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildTypePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.device_hub,
          text: selectedType ?? "Select Device Type",
          isError: isSubmitted && selectedType == null,
          onTap: _showTypePicker,
          enabled: true,
        ),
        if (isSubmitted && selectedType == null)
          _buildErrorText("Device type is required!"),
      ],
    );
  }

  Widget _buildStatusPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.settings,
          text: selectedStatus ?? "Select Status",
          isError: isSubmitted && selectedStatus == null,
          onTap: _showStatusPicker,
          enabled: true,
        ),
        if (isSubmitted && selectedStatus == null)
          _buildErrorText("Status is required!"),
      ],
    );
  }

  Widget _buildAssignedToPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.school,
          text: selectedAssignedTo ?? "Select School (Optional)",
          isError: false,
          onTap: _showAssignedToPicker,
          enabled: true,
        ),
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
            selectedType != null &&
            selectedStatus != null) {
          final updatedDevice = Device(
            name: _nameController.text,
            type: selectedType,
            status: selectedStatus,
            assignedTo: selectedAssignedTo,
            imagePath: _imagePath,
            maintenanceHistory: widget.device.maintenanceHistory,
          );
          Navigator.pop(context, updatedDevice);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Device updated successfully!")),
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

  void _showTypePicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: deviceTypes.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(deviceTypes[index]),
                  onTap:
                      () => setState(() {
                        selectedType = deviceTypes[index];
                        Navigator.pop(context);
                      }),
                ),
          ),
    );
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: statuses.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(statuses[index]),
                  onTap:
                      () => setState(() {
                        selectedStatus = statuses[index];
                        Navigator.pop(context);
                      }),
                ),
          ),
    );
  }

  void _showAssignedToPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            children: [
              ListTile(
                title: const Text("None"),
                onTap:
                    () => setState(() {
                      selectedAssignedTo = null;
                      Navigator.pop(context);
                    }),
              ),
              ...schools.map(
                (school) => ListTile(
                  title: Text(school),
                  onTap:
                      () => setState(() {
                        selectedAssignedTo = school;
                        Navigator.pop(context);
                      }),
                ),
              ),
            ],
          ),
    );
  }
}
