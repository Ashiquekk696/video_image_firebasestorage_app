import 'dart:io';

import 'package:assignment1/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<File?> myFile = Rx<File?>(null);
  RxList<String> imageFiles = RxList<String>([]);
  RxBool isLoading = false.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File? file = File(result.files.first.path!);
        if (file.existsSync()) {
          int fileSizeInBytes = await file.length();
          if (fileSizeInBytes <= 10 * 1024 * 1024) {
            myFile.value = file;
           
          } else {
            Fluttertoast.showToast(
              msg: "File size exceeds 10MB. Please select a smaller file",
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "File does not exist",
            backgroundColor: AppColors.red,
          );
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      Fluttertoast.showToast(
        msg: "Error picking file",
        backgroundColor: AppColors.red,
      );
    }
  }

  // bool _isVideoFile(File file) {
  //   String ext = file.path.split('.').last.toLowerCase();
  //   return ext == 'mp4' || ext == 'mov' || ext == 'avi' || ext == 'mkv';
  // }

  Future<void> uploadFile(File file) async {
    try {
      if (myFile.value != null) {
        isLoading.value = true;
        FirebaseStorage storage = FirebaseStorage.instance;
        String bucketName = 
        //_isVideoFile(file) ? 'videos' :
         'images';
        Reference ref = storage.ref().child(bucketName).child('${DateTime.now()}.jpeg');
        await ref.putFile(file);
        Fluttertoast.showToast(
          msg: "File uploaded successfully",
        );
      } else {
        print('No file selected.');
        Fluttertoast.showToast(
          msg: "No file selected",
          backgroundColor: AppColors.red,
        );
      }
    } catch (e) {
      print('Error uploading file: $e');
      Fluttertoast.showToast(
        msg: "Error uploading file",
        backgroundColor: AppColors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
  var hh= "".obs;

Future<void> fetchImages() async {
  try {
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result = await storage.ref('images').listAll();
     // Change 'videos' to 'images'
  
    imageFiles.assignAll(result.items.map((item) => item.name).toList());
       hh.value =await storage.ref('images').child(imageFiles.last).getDownloadURL();
  } catch (e) {
    print('Error fetching images: $e');
    Fluttertoast.showToast(
      msg: "Error fetching images",
      backgroundColor: AppColors.red,
    );
  }
}

}
