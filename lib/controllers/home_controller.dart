import 'dart:io';

import 'package:assignment1/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<File?> myFile = Rx<File?>(null);
  RxList<String> imageFiles = RxList<String>([]);
  RxList<String> videoFiles = RxList<String>([]);
  RxBool isLoading = false.obs;
  var fileName = "".obs;


  @override
  void onInit() {
    super.onInit();
    fetchImages();
    fetchVideos();
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
            _isVideoFile(file)?fileName.value=file.path:"";
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

  bool _isVideoFile(File file) {
    String ext = file.path.split('.').last.toLowerCase();
    return ext == 'mp4' || ext == 'mov' || ext == 'avi' || ext == 'mkv';
  }

  Future<void> uploadFile(File file) async {
    try {
      if (myFile.value != null) {
        isLoading.value = true;
        FirebaseStorage storage = FirebaseStorage.instance;
        String bucketName =
            _isVideoFile(file) ? 'videos' : 'images';
        Reference ref = storage.ref().child(bucketName).child('${DateTime.now()}.jpeg');
        await ref.putFile(file);
        await fetchImages();
        await fetchVideos(); // Update the videos list after uploading
        Fluttertoast.showToast(
          msg: "File uploaded successfully",
        );
        myFile.value = null;
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

  Future<void> fetchImages() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage.ref('images').listAll();
      imageFiles.clear(); // Clear existing image URLs
      for (Reference ref in result.items) {
        String downloadURL = await ref.getDownloadURL();
        imageFiles.add(downloadURL);
      }
    } catch (e) {
      print('Error fetching images: $e');
      Fluttertoast.showToast(
        msg: "Error fetching images",
        backgroundColor: AppColors.red,
      );
    }
  }

  Future<void> fetchVideos() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage.ref('videos').listAll();
      videoFiles.clear(); // Clear existing video URLs
      for (Reference ref in result.items) {
        String downloadURL = await ref.getDownloadURL();
        videoFiles.add(downloadURL);
      }
    } catch (e) {
      print('Error fetching videos: $e');
      Fluttertoast.showToast(
        msg: "Error fetching videos",
        backgroundColor: AppColors.red,
      );
    }
  }
}
