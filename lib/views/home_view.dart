import 'dart:io';

import 'package:assignment1/constants/colors.dart';
import 'package:assignment1/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('File Upload'),
        ),
        body: controller.isLoading.value
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please wait ...File is uploading",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    CircularProgressIndicator(color: AppColors.red),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () => controller.pickFile(),
                      icon: Icon(Icons.attach_file),
                      label: Text('Select file'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(() {
                      if (controller.myFile.value != null) {
                        File file = controller.myFile.value!;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              file,
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (controller.myFile.value != null) {
                          controller.uploadFile(controller.myFile.value!);
                        }
                      },
                      icon: Icon(Icons.upload),
                      label: Text('Upload'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Text(controller.hh.value??"ggg"),
Image.network(controller.hh.value),
                    Text(controller.imageFiles.last.toString())
                  ],
                ),
              ),
      ),
    );
  }
}
