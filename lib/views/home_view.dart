import 'dart:io';

import 'package:assignment1/widgets/button_widget.dart';
import 'package:assignment1/widgets/video_display_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:assignment1/constants/colors.dart';
import 'package:assignment1/constants/text_style.dart';
import 'package:assignment1/controllers/home_controller.dart';

import '../widgets/loader_widget.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  Widget buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: controller.imageFiles.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              controller.imageFiles[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          title: Text('File Upload'),
        ),
        body: controller.isLoading.value
            ? LoaderWidget()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: MyButtonWidget(
                          onPressed: () => controller.pickFile(),
                          icon: Icon(Icons.attach_file),
                          label: Text('Select file'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        if (controller.myFile.value != null) {
                          File file = controller.myFile.value!;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: controller.fileName.value != null
                                  ? Text(
                                      controller.fileName.value,
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Image.file(
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
                      Visibility(
                          visible: controller.myFile.value != null,
                          child: SizedBox(
                            height: 1,
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: MyButtonWidget(
                          onPressed: () {
                            if (controller.myFile.value != null) {
                              controller.uploadFile(controller.myFile.value!);
                            }
                          },
                          icon: Icon(Icons.upload),
                          label: Text('Upload'),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Visibility(
                        visible: controller.imageFiles.isNotEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Uploaded Images",
                              style: MyTextStyle.medium
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //   Text(controller.videoFiles.first??"",style: TextStyle(color: Colors.white),),
                      Visibility(
                        visible: controller.imageFiles.isNotEmpty,
                        child: buildGridView(),
                      ),
SizedBox(
                        height: 25,
                      ),
                      Visibility(
                        visible: controller.videoFiles.isNotEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Uploaded Videos",
                              style: MyTextStyle.medium
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                          visible: controller.videoFiles.isNotEmpty,
                          child: myVideoGrid()),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget myVideoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: controller.videoFiles.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: controller.videoFiles.value != null
                ? GestureDetector(
                  onTap: (){
                    Get.to(VideoDisplayWidget(videoUrl:  controller.videoFiles[index]));
                  },
                  child: VideoDisplayWidget(
                      videoUrl: controller.videoFiles[index],
                    ),
                )
                : Icon(
                    Icons.video_library, // Icon to use as a placeholder
                    size: 48, // Adjust the size of the icon as needed
                    color:
                        Colors.grey, // Adjust the color of the icon as needed
                  ),
          ),
        );
      },
    );
  }
}
