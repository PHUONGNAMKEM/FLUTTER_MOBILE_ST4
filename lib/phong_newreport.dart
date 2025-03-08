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
  String? selectedRoom;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
              _buildTextField("Report Name", _nameController),
              const SizedBox(height: 20),
              _buildTextField(
                "Description",
                _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _buildDatePicker(
                "Date",
                startDate,
                (date) => setState(() => startDate = date),
              ),
              const SizedBox(height: 20),
              _buildTimePicker(
                "Time",
                endDate,
                (time) => setState(() => endDate = time),
              ),
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

  // 🌟 AppBar
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

  // 🌟 TextField chung
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

  // 🌟 Date Picker
  Widget _buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onSelected,
  ) {
    return _buildSelectionBox(
      icon: Icons.calendar_today,
      text:
          date != null
              ? "${date.day} ${_getMonthName(date.month)}, ${date.year}"
              : "Select Date",
      isError: isSubmitted && date == null,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) setState(() => startDate = pickedDate);
      },
    );
  }

  // 🌟 Time Picker
  Widget _buildTimePicker(
    String label,
    DateTime? time,
    Function(DateTime) onSelected,
  ) {
    return _buildSelectionBox(
      icon: Icons.access_time,
      text:
          time != null
              ? "${time.hour}:${time.minute.toString().padLeft(2, '0')}"
              : "Select Time",
      isError: isSubmitted && time == null,
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
    );
  }

  // 🌟 Room Picker
  Widget _buildRoomPicker() {
    return _buildSelectionBox(
      icon: Icons.door_front_door_outlined,
      text: selectedRoom ?? "Select Room",
      isError: isSubmitted && selectedRoom == null,
      onTap: _showRoomPicker,
    );
  }

  // 🌟 Submit Button
  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        setState(() => isSubmitted = true); // Kích hoạt kiểm tra lỗi

        if (_formKey.currentState!.validate() &&
            startDate != null &&
            endDate != null &&
            selectedRoom != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Report created successfully!")),
          );
          Future.delayed(
            const Duration(seconds: 1),
            () => Navigator.pop(context),
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

  // 🌟 Hộp chọn chung (dùng cho DatePicker, TimePicker, RoomPicker)
  Widget _buildSelectionBox({
    required IconData icon,
    required String text,
    required bool isError,
    required Function() onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isError ? Colors.red : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.blue),
                Text(
                  text,
                  style: TextStyle(color: isError ? Colors.red : Colors.grey),
                ),
              ],
            ),
          ),
        ),
        if (isError) _buildErrorText("This field is required!"),
      ],
    );
  }

  // 🌟 Hiển thị lỗi
  Widget _buildErrorText(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 12),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  // 🌟 Hiển thị danh sách phòng
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

  // 🌟 Lấy tên tháng
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
