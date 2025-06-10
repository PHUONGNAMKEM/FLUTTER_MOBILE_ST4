import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_presentation_lastsegment/model/classes_model.dart';
import 'device.dart';

class DeviceService {
  Future<List<Device>> fetchDevices() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('devices').get();
    return snapshot.docs.map((doc) => Device.fromFirestore(doc)).toList();
  }

  Stream<List<Device>> deviceStream() {
    return FirebaseFirestore.instance
        .collection('devices')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Device.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addDevice(Device device) async {
    await FirebaseFirestore.instance.collection('devices').add({
      'name': device.name,
      'type': device.type,
      'status': device.status,
      'assignedTo': device.assignedTo,
      'imagePath': device.imagePath,
      'maintenanceHistory': device.maintenanceHistory,
    });
  }

  Future<void> updateDevice(String docId, Device device) async {
    await FirebaseFirestore.instance.collection('devices').doc(docId).update({
      'name': device.name,
      'type': device.type,
      'status': device.status,
      'assignedTo': device.assignedTo,
      'imagePath': device.imagePath,
      'maintenanceHistory': device.maintenanceHistory,
    });
  }

  Future<void> deleteDevice(String docId) async {
    await FirebaseFirestore.instance.collection('devices').doc(docId).delete();
  }

  Future<Device?> getDeviceById(String docId) async {
    final doc =
        await FirebaseFirestore.instance.collection('devices').doc(docId).get();
    if (doc.exists) {
      return Device.fromFirestore(doc);
    }
    return null;
  }

  Future<List<ClassModel>> fetchClasses() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('classes').get();
    return snapshot.docs.map((doc) => ClassModel.fromFirestore(doc)).toList();
  }
}
