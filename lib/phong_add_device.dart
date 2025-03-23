// Trong phong_add_device.dart
import 'package:flutter/material.dart';

import 'device.dart';

void main() => runApp(const MyFormDevice());

class MyFormDevice extends StatelessWidget {
  const MyFormDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AddDeviceScreen());
  }
}

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  bool isSubmitted = false;
  String? selectedType;
  String? selectedStatus;
  String? selectedAssignedTo;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final List<String> deviceTypes = ["Máy chiếu", "Máy in", "Máy tính", "Khác"];
  final List<String> statuses = ["Sẵn sàng", "Đang sử dụng", "Bảo trì"];
  final List<String> schools = [
    "school123",
    "school456",
    "school789",
  ]; // ID trường, có thể lấy từ Firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Add Device"),
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
          isError: false, // Không bắt buộc
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
          final newDevice = Device(
            name: _nameController.text,
            type: selectedType!,
            status: selectedStatus!,
            assignedTo: selectedAssignedTo,
            maintenanceHistory: [], // Khởi tạo rỗng
          );
          Navigator.pop(context, newDevice); // Trả về để cập nhật UI
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Device added successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all required fields")),
          );
        }
      },
      child: const Center(
        child: Text(
          "Add Device",
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
