import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/constants.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Models/recipe.dart';
import '../../Widgets/MyButton.dart';
import '../../Widgets/text_input_field.dart';

class EditRecipe extends StatefulWidget {
  Recipe obj;
  EditRecipe({required this.obj, super.key});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  late TextEditingController nameController;
  late int serving;
  File? image;
  bool hasChangedImage = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.obj.name.toString());
    serving = widget.obj.servings!;
    image = File(widget.obj.image!);
  }

  void updateServing(int value) {
    setState(() {
      serving = value;
    });
  }

  // IMAGE CODE

  // Future pickImage() async {
  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedFile == null) return;
  //     setState(() {
  //       image = File(pickedFile.path);
  //       hasChangedImage = true;
  //     });
  //   } on PlatformException {}
  // }

  pickImage(ImageSource imageType) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imageType, maxWidth: 480, maxHeight: 600);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() {
        setState(() => this.image = tempImage);
        hasChangedImage = true;
      });
      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void imagePickerOption() {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: themeColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Container(
                color: Colors.white,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Pic Image From",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera),
                        label: const Text("CAMERA"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.image),
                        label: const Text("GALLERY"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("CANCEL"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    int rid = widget.obj.id!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'Edit a Recipe',
          style: headingTextStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextInputField(
                  controller: nameController,
                  labelText: 'Name',
                  icon: Icons.dining_outlined,
                ),
              ),
              const SizedBox(
                height: 5,
              ),

              // SizedBox(
              //   height: 200,
              //   width: 300,
              //   child: Column(
              //     children: [
              //       Stack(
              //         children: [
              //           Container(
              //             height: 150,
              //             width: 150,
              //             decoration: BoxDecoration(
              //               image: DecorationImage(
              //                 image: hasChangedImage
              //                     ? FileImage(image!)
              //                     : NetworkImage(imgpath + widget.obj.image!)
              //                         as ImageProvider<Object>,
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //               bottom: 0,
              //               right: 0,
              //               child: GestureDetector(
              //                   onTap: () async {
              //                     await pickImage();
              //                   },
              //                   child: const Icon(
              //                     Icons.camera_alt_outlined,
              //                     size: 30,
              //                   )))
              //         ],
              //       )
              //     ],
              //   ),
              // ),

              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo, width: 5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: hasChangedImage
                                  ? FileImage(image!)
                                  : NetworkImage(imgpath + widget.obj.image!)
                                      as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: IconButton(
                        onPressed: imagePickerOption,
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              // SERVINGS
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Serving',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (serving > 1) {
                                    serving--;
                                    updateServing(serving);
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              serving.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  serving++;
                                  updateServing(serving);
                                });
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      text: 'Save',
                      backgroundColor: themeColor,
                      buttonwidth: 150,
                      onPress: () async {
                        Recipe r = Recipe();
                        //image = File(image!.path);
                        if (hasChangedImage) {
                          image = File(image!.path);
                        }
                        await r.editrecipe(
                            image!, nameController.text, serving, rid);
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      },
                      textColor: Colors.white,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    MyButton(
                      text: 'Cancel',
                      backgroundColor: Colors.red,
                      buttonwidth: 150,
                      onPress: () => Navigator.of(context).pop(),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
