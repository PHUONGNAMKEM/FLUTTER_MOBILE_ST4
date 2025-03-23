import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/phong_edit_device.dart'; // Import EditDeviceScreen
import 'package:image_picker/image_picker.dart'; // Thêm image_picker
import 'dart:io' show File;

void main() {
  runApp(const MyApp_Devices());
}

class MyApp_Devices extends StatelessWidget {
  const MyApp_Devices({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DeviceListScreen(),
    );
  }
}

// Model Device
class Device {
  String name;
  String type;
  String status;
  String? assignedTo;
  String? imagePath; // Thêm trường imagePath
  List<Map<String, dynamic>>? maintenanceHistory;

  Device({
    required this.name,
    required this.type,
    required this.status,
    this.assignedTo,
    this.imagePath,
    this.maintenanceHistory,
  });
}

// Danh sách thiết bị mẫu
List<Device> devices = [
  Device(
    name: "Máy chiếu Sony",
    type: "Máy chiếu",
    status: "Sẵn sàng",
    assignedTo: "school123",
    imagePath: "images_device/maychieusony.jpg", // Thêm imagePath
    maintenanceHistory: [
      {"date": "2025-03-10", "status": "Bảo trì", "technician": "tech123"},
      {"date": "2025-03-15", "status": "Sẵn sàng", "technician": "tech123"},
    ],
  ),
  Device(
    name: "Máy in HP",
    type: "Máy in",
    status: "Đang sử dụng",
    assignedTo: "school456",
    imagePath: "images_device/mayin.jpg", // Thêm imagePath
    maintenanceHistory: [],
  ),
  Device(
    name: "Laptop Dell",
    type: "Máy tính",
    status: "Bảo trì",
    imagePath: "images_device/laptopdell.jpg", // Thêm imagePath
    maintenanceHistory: [
      {"date": "2025-03-20", "status": "Bảo trì", "technician": "tech456"},
    ],
  ),
];

// DeviceListScreen
class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  TextEditingController searchController = TextEditingController();
  List<Device> filteredDevices = devices;

  void addDevice() async {
    final newDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDeviceScreen()),
    );

    if (newDevice != null) {
      setState(() {
        devices.add(newDevice as Device);
        filterDevices(searchController.text);
      });
    }
  }

  void editDevice(int index) async {
    final updatedDevice = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDeviceScreen(device: devices[index]),
      ),
    );

    if (updatedDevice != null) {
      setState(() {
        devices[index] = updatedDevice;
        filterDevices(searchController.text);
      });
    }
  }

  void filterDevices(String query) {
    setState(() {
      filteredDevices =
          devices
              .where(
                (device) =>
                    device.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void deleteDevice(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Xác nhận xóa"),
            content: const Text("Bạn có chắc chắn muốn xóa thiết bị này?"),
            actions: [
              TextButton(
                child: const Text("Xóa"),
                onPressed: () {
                  setState(() {
                    devices.removeAt(index);
                    filterDevices(searchController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: filterDevices,
          decoration: const InputDecoration(
            hintText: "Tìm kiếm thiết bị...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: filteredDevices.length,
        itemBuilder: (context, index) {
          final device = filteredDevices[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceDetailScreen(device: device),
                  ),
                );
              },
              leading:
                  device.imagePath != null
                      ? CircleAvatar(
                        backgroundImage:
                            kIsWeb
                                ? NetworkImage(device.imagePath!)
                                    as ImageProvider
                                : FileImage(File(device.imagePath!))
                                    as ImageProvider,
                        radius: 25,
                      )
                      : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.device_unknown, color: Colors.white),
                        radius: 25,
                      ),
              title: Text(
                device.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Loại: ${device.type}"),
                  Text("Trạng thái: ${device.status}"),
                  if (device.assignedTo != null)
                    Text("Đã thuê: ${device.assignedTo}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () => editDevice(devices.indexOf(device)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteDevice(devices.indexOf(device)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addDevice,
        backgroundColor: const Color.fromRGBO(69, 209, 253, 1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// AddDeviceScreen
class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  bool isSubmitted = false;
  String? selectedType;
  String? selectedStatus;
  String? selectedAssignedTo;
  File? _imageFile;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<String> deviceTypes = ["Máy chiếu", "Máy in", "Máy tính", "Khác"];
  final List<String> statuses = ["Sẵn sàng", "Đang sử dụng", "Bảo trì"];
  final List<String> schools = ["school123", "school456", "school789"];

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
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : null,
                      child:
                          _imageFile == null
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
          final newDevice = Device(
            name: _nameController.text,
            type: selectedType!,
            status: selectedStatus!,
            assignedTo: selectedAssignedTo,
            imagePath: _imagePath,
            maintenanceHistory: [],
          );
          Navigator.pop(context, newDevice);
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

// DeviceDetailScreen
class DeviceDetailScreen extends StatelessWidget {
  final Device device;

  const DeviceDetailScreen({required this.device, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Information"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            device.imagePath != null
                ? CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      kIsWeb
                          ? NetworkImage(device.imagePath!) as ImageProvider
                          : FileImage(File(device.imagePath!)) as ImageProvider,
                )
                : const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.device_unknown,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
            const SizedBox(height: 20),
            Text(
              device.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Loại: ${device.type}",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Trạng thái: ${device.status}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            if (device.assignedTo != null)
              Text(
                "Đã thuê: ${device.assignedTo}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (device.maintenanceHistory != null &&
                device.maintenanceHistory!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    const Text(
                      "Lịch sử bảo trì:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...device.maintenanceHistory!.map(
                      (history) => Text(
                        "${history['date']}: ${history['status']} (Kỹ thuật viên: ${history['technician']})",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
