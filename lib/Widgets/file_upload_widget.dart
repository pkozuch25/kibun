import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';

class FileUploadWidget extends StatelessWidget {
  final BuildContext context;
  final void Function() getImageFromGallery;
  final void Function() getImageFromCamera;
  final void Function() deleteFile;
  final File? file;

  const FileUploadWidget({
    super.key, 
    required this.context,
    required this.file,
    required this.getImageFromGallery,
    required this.getImageFromCamera,
    required this.deleteFile,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          showDragHandle: true,
          backgroundColor: ColorPalette.black500, 
          builder: (context) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 70),
                child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (context) {
                          return Column(
                            children: [
                              ListTile(title: const Text('Gallery'), textColor: Colors.grey.shade800, onTap: () {
                                Navigator.pop(context);
                                getImageFromGallery();
                              }, trailing: const Icon(Icons.photo)),
                              const Divider(thickness: 1, indent: 5, endIndent: 5, height: 0,),
                              ListTile(title: const Text('Take photo'), textColor: Colors.grey.shade800, onTap: () {
                                Navigator.pop(context);
                                getImageFromCamera();
                              }, trailing: const Icon(Icons.camera))
                            ],
                          );
                        }
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          dashPattern: const [10, 4],
          strokeCap: StrokeCap.round,
          color: ColorPalette.teal500,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(.4),
              borderRadius: BorderRadius.circular(10)
            ),
            child: file == null ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_upload, color: ColorPalette.neutralsWhite, size: 40,),
                Text('Upload photo', style: TextStyle(color: ColorPalette.neutralsWhite),)
              ],
            ): Stack(
              clipBehavior: Clip.none,
              children: [
                Image.file(file!),
                Positioned(
                  top: -10,
                  right: -10,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 14.5,
                        right: 14.7,
                        child: Container(
                          width: 19,
                          height: 19,
                          decoration: BoxDecoration(
                            color: ColorPalette.errorColor.withOpacity(0.9),
                            shape: BoxShape.circle
                          ),
                        ),
                      ),
                      CloseButton(
                        style: const ButtonStyle(iconSize: WidgetStatePropertyAll(18)),
                        color: Colors.white,
                        onPressed: () => deleteFile(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
