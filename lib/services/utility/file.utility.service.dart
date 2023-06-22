// import 'dart:io';
//
// import 'package:eatery/constants/global_variables.dart';
// import 'package:flutter/material.dart';
//
// class FileUtilityService {
//   static String resourcesDirectory = GlobalVariables.resourcesDirectory!;
//   static String resourcesDirectoryAbs = GlobalVariables.resourcesDirectoryAbs!;
//
//   static String importInResources(String pathOrUrl) {
//     if (pathOrUrl.startsWith('http')) {
//       try {
//         final uri = Uri.parse(pathOrUrl);
//         if (uri.isAbsolute) {
//           final fileName = Uri.decodeFull(uri.pathSegments.last);
//           final file = File('$resourcesDirectory/$fileName');
//           file.createSync(recursive: true);
//           HttpClient().getUrl(uri).then((HttpClientRequest request) {
//             return request.close();
//           }).then((HttpClientResponse response) {
//             response.pipe(file.openWrite());
//           });
//           return '${Uri.encodeComponent(resourcesDirectory)}/$fileName';
//         }
//         throw Exception('Invalid URL: $pathOrUrl');
//       } catch (e) {
//         throw Exception('Error downloading file from URL: $e');
//       }
//     } else {
//       final file = File(pathOrUrl);
//       if (file.existsSync()) {
//         final fileName = file.path.split('/').last;
//         final newFilePath = '$resourcesDirectoryAbs/$fileName';
//         try {
//           file.copySync(newFilePath);
//           return '$resourcesDirectory/$fileName';
//         } catch (e) {
//           throw Exception('Error copying file to base directory: $e');
//         }
//       }
//       throw Exception('File does not exist: $pathOrUrl');
//     }
//   }
//
//   static String getAbsolutePath(String path) {
//     if (path.startsWith(resourcesDirectory)) {
//       return path.replaceFirst(resourcesDirectory, resourcesDirectoryAbs);
//     } else {
//       return path;
//     }
//   }
//
//   static String getRelativePath(String path) {
//     if (path.startsWith(resourcesDirectoryAbs)) {
//       return path.replaceFirst(resourcesDirectoryAbs, resourcesDirectory);
//     } else {
//       return path;
//     }
//   }
//
//   static bool deleteResource(String path) {
//     String absPath = getAbsolutePath(path);
//     File file = File(absPath);
//     if (file.existsSync()) {
//       file.deleteSync();
//       return true;
//     }
//     return false;
//   }
//
//   static ImageProvider getImageFromAbsOrRelPath(String? path) {
//     if (path == null) {
//       return Image.asset('assets/images/default.jpg').image;
//     }
//     String absPath = getAbsolutePath(path);
//     File file = File(absPath);
//     if (file.existsSync()) {
//       return Image.file(file).image;
//     }
//     return Image.asset('assets/images/default.jpg').image;
//   }
// }
