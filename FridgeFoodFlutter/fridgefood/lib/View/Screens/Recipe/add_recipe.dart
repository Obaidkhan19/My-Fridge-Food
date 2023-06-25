import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../Models/recipe.dart';

//

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  TextEditingController nameController = TextEditingController();

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    setState(() {});
  }

  int? fridgeid;
  int serving = 1;

  // IMAGE CODE
  File? image;

  pickImage(ImageSource imageType) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imageType, maxWidth: 480, maxHeight: 600);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() {
        setState(() => this.image = tempImage);
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'Add a Recipe',
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
              // image != null
              //     ? Image.file(
              //         image!,
              //         height: 110,
              //         width: 110,
              //         fit: BoxFit.cover,
              //       )
              //     : InkWell(
              //         onTap: () {},
              //         child: Ink(
              //           height: 110,
              //           width: 110,
              //           color: const Color.fromARGB(255, 180, 173, 173),
              //           child:
              //               const Icon(Icons.camera_enhance_outlined, size: 40),
              //         ),
              //       ),
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
                        child: image != null
                            ? Image.file(
                                image!,
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/addrecipe.png',
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
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
                        if (image == null) {
                          final ByteData assetByteData =
                              await rootBundle.load('assets/addrecipe.png');
                          image = File(
                              '${(await getTemporaryDirectory()).path}/addrecipe.png');
                          image!.writeAsBytesSync(assetByteData.buffer
                              .asUint8List(assetByteData.offsetInBytes,
                                  assetByteData.lengthInBytes));
                        }
                        if (nameController.text == '') {
                          Utils.snackBar('Enter Recipe Name', context);
                        } else if (nameController.text != '') {
                          Recipe r = Recipe();
                          image = File(image!.path);
                          String? response = await r.addRecipe(
                            image!,
                            nameController.text,
                            serving,
                            fridgeid!,
                          );
                          print(response);
                          if (response == "\"Exist\"") {
                            Utils.snackBar('Recipe Exist', context);
                          } else {
                            Utils.snackBar('Recipe added sucessfully', context);
                            Navigator.pop(context);
                          }
                        }
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
