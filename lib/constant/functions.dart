import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  // static Future<bool> requestInternetPermission() async {
  //   var status = await Permission.internet.status;

  //   if (status.isGranted) {
  //     // Internet permission is already granted
  //     return true;
  //   } else {
  //     // Request internet permission
  //     var result = await Permission.internet.request();
  //     return result == PermissionStatus.granted;
  //   }
  // }

  static Future<bool> requestGalleryPermission() async {
    var status = await Permission.photos.status;

    if (status.isGranted) {
      // Gallery permission is already granted
      return true;
    } else {
      // Request gallery permission
      var result = await Permission.photos.request();
      return result == PermissionStatus.granted;
    }
  }

  static Future<bool> requestContactsPermission() async {
    var status = await Permission.contacts.status;

    if (status.isGranted) {
      // Contacts permission is already granted
      return true;
    } else {
      // Request contacts permission
      var result = await Permission.contacts.request();
      return result == PermissionStatus.granted;
    }
  }
}
