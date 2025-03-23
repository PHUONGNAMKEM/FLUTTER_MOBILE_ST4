import 'package:flutter/material.dart';

void main() => runApp(const MyReport());

class MyReport extends StatelessWidget {
  const MyReport({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddProjectScreen();
  }
}

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  bool isSubmitted = false;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedDevice;
  String? selectedSchool;
  String? selectedRoom;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> devices = ["Device 1", "Device 2", "Device 3", "Device 4"];
  final List<String> schools = ["School A", "School B", "School C", "School D"];
  final List<String> rooms = ["Room 1", "Room 2", "Room 3", "Room 4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildDevicePicker(),
              const SizedBox(height: 20),
              _buildTextField(
                "Description",
                _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _buildDatePicker(),
              const SizedBox(height: 20),
              _buildTimePicker(),
              const SizedBox(height: 20),
              _buildSchoolPicker(),
              const SizedBox(height: 20),
              _buildRoomPicker(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
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
        "Add Report",
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
      actions: const [
        Icon(Icons.notifications, color: Colors.black),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.calendar_today,
          text:
              startDate != null
                  ? "${startDate!.day} ${_getMonthName(startDate!.month)}, ${startDate!.year}"
                  : "Select Date",
          isError: isSubmitted && startDate == null,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) setState(() => startDate = pickedDate);
          },
        ),
        if (isSubmitted && startDate == null)
          _buildErrorText("Date is required!"),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.access_time,
          text:
              endDate != null
                  ? "${endDate!.hour}:${endDate!.minute.toString().padLeft(2, '0')}"
                  : "Select Time",
          isError: isSubmitted && endDate == null,
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              setState(() {
                endDate = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
              });
            }
          },
        ),
        if (isSubmitted && endDate == null)
          _buildErrorText("Time is required!"),
      ],
    );
  }

  Widget _buildDevicePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.devices,
          text: selectedDevice ?? "Select Device",
          isError: isSubmitted && selectedDevice == null,
          onTap: _showDevicePicker,
        ),
        if (isSubmitted && selectedDevice == null)
          _buildErrorText("Device is required!"),
      ],
    );
  }

  Widget _buildSchoolPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.school,
          text: selectedSchool ?? "Select School",
          isError: isSubmitted && selectedSchool == null,
          onTap: _showSchoolPicker,
        ),
        if (isSubmitted && selectedSchool == null)
          _buildErrorText("School is required!"),
      ],
    );
  }

  Widget _buildRoomPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionBox(
          icon: Icons.door_front_door_outlined,
          text: selectedRoom ?? "Select Room",
          isError: isSubmitted && selectedRoom == null,
          onTap: _showRoomPicker,
        ),
        if (isSubmitted && selectedRoom == null)
          _buildErrorText("Room is required!"),
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
            selectedDevice != null &&
            startDate != null &&
            endDate != null &&
            selectedSchool != null &&
            selectedRoom != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Report created successfully!")),
          );
          Future.delayed(
            const Duration(seconds: 1),
            () => Navigator.pop(context),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all required fields")),
          );
        }
      },
      child: const Center(
        child: Text(
          "Add Report",
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
  }) {
    return InkWell(
      onTap: onTap,
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
            Icon(icon, color: const Color.fromRGBO(69, 209, 253, 1)),
            Text(
              text,
              style: TextStyle(color: isError ? Colors.red : Colors.grey),
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

  void _showDevicePicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: devices.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(devices[index]),
                  onTap:
                      () => setState(() {
                        selectedDevice = devices[index];
                        Navigator.pop(context);
                      }),
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

  void _showRoomPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: rooms.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(rooms[index]),
                  onTap:
                      () => setState(() {
                        selectedRoom = rooms[index];
                        Navigator.pop(context);
                      }),
                ),
          ),
    );
  }

  String _getMonthName(int month) =>
      [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ][month - 1];
}
