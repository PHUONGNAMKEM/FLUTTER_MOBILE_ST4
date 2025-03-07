import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddProjectScreen(),
    );
  }
}

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  String selectedTaskGroup = "Work";
  String projectName = "";
  String description = "";
  DateTime? startDate;
  DateTime? endDate;
  String? selectedRoom;

  final List<String> rooms = ["Room 1", "Room 2", "Room 3", "Room 4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
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
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: const [
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildDropdown("Task Group", selectedTaskGroup, [
            //   "Work",
            //   "Personal",
            // ]),
            const SizedBox(height: 20),
            _buildTextField("Report Name", (value) => projectName = value),
            const SizedBox(height: 20),
            _buildTextField(
              "Description",
              (value) => description = value,
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
            _buildRoomPicker(), // Room Picker
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Widget _buildDropdown(String title, String value, List<String> items) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //         DropdownButton(
  //           value: value,
  //           underline: Container(),
  //           onChanged:
  //               (newValue) =>
  //                   setState(() => selectedTaskGroup = newValue as String),
  //           items:
  //               items
  //                   .map(
  //                     (item) =>
  //                         DropdownMenuItem(value: item, child: Text(item)),
  //                   )
  //                   .toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTextField(
    String label,
    Function(String) onChanged, {
    int maxLines = 1,
  }) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
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

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onSelected,
  ) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          onSelected(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   label,
            //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            const Icon(
              Icons.calendar_today,
              color: Color.fromARGB(255, 69, 259, 203),
            ),
            Text(
              date != null
                  ? "${date.day} ${_getMonthName(date.month)}, ${date.year}"
                  : "Select Date",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    DateTime? time,
    Function(DateTime) onSelected,
  ) {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          DateTime now = DateTime.now();
          DateTime selectedTime = DateTime(
            now.year,
            now.month,
            now.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          onSelected(selectedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   label,
            //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            const Icon(
              Icons.access_time_sharp,
              color: Color.fromARGB(255, 69, 259, 203),
            ),
            Text(
              time != null
                  ? "${time.hour}:${time.minute.toString().padLeft(2, '0')}"
                  : "Select Time",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomPicker() {
    return InkWell(
      onTap: () => _showRoomPicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const Text(
            //   "Room",
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            const Icon(
              Icons.door_front_door_outlined,
              color: Color.fromARGB(255, 69, 259, 203),
            ),
            Text(
              selectedRoom ?? "Select Room",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoomPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          child: Column(
            children: [
              const Text(
                "Select a Room",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(rooms[index]),
                      onTap: () {
                        setState(() {
                          selectedRoom = rooms[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 69, 259, 203),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
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

  String _getMonthName(int month) {
    const months = [
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
    ];
    return months[month - 1];
  }
}
