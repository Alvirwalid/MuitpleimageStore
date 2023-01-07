import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mela/display.dart';
import 'package:uuid/uuid.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;

  openImages() async {
    try {
      List<XFile> pickedfiles =
          await imgpicker.pickMultiImage(requestFullMetadata: true);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {});

        print("imaaaage ${imagefiles![0].path.toString()}");
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  Future uploadFile() async {}

  List<String> _imagesUrl = [];
  Future<void> uploadImages() async {
    final uuid = Uuid().v4();
    int i = 0;
    for (XFile imageFile in imagefiles!) {
      try {
        var ref = FirebaseStorage.instance
            .ref()
            .child('ListingImages')
            .child(Uuid().v4())
            .child(i.toString() + '.jpg');

        await ref.putFile(File(imageFile.path));

        var url = await ref.getDownloadURL();

        _imagesUrl.add(url);
        setState(() {});

        ++i;
      } catch (err) {
        print(err);
      }
    }
    setState(() {});

    await FirebaseFirestore.instance
        .collection('product')
        .doc(uuid)
        .set({'id': uuid, 'name': 'Rifa', 'image': _imagesUrl});
    print(_imagesUrl);
  }

  // Future storedata() async {
  //   final uuid = Uuid().v4();
  //   if (imagefiles!.length != 0) {
  //     // for (var i = 1; i < imagefiles!.length; i++) {
  //     //   UploadTask uploadTask;

  //     //   Reference ref = FirebaseStorage.instance
  //     //       .ref()
  //     //       .child('flutter-tests')
  //     //       .child('/some-image.jpg');
  //     //   uploadTask = ref.putFile(io.File(imagefiles![i].path));
  //     // }

  //     for (var element in imagefiles!) {
  //       setState(() {
  //         UploadTask uploadTask;
  //         Reference ref = FirebaseStorage.instance.ref().child('flutter-tests');
  //         uploadTask =
  //             ref.child('/$element.jpg').putFile(io.File(element.path));
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  onPressed: () {
                    openImages();
                  },
                  child: Text("Open Images")),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await uploadImages();
                  },
                  child: Text("Upload ")),
              _imagesUrl.isNotEmpty
                  ? Text("${_imagesUrl[0]}")
                  : const Text('Url'),
              Divider(),
              Text("Picked Files:"),
              Divider(),
              imagefiles != null
                  ? GridView.builder(
                      shrinkWrap: true,
                      itemCount: imagefiles!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5, crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Container(
                            child: Card(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.file(io.File(imagefiles![index].path)),
                          ),
                        ));
                      },
                    )
                  : Container(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return Displaycreen();
                      },
                    ));
                  },
                  child: Text('Display'))
            ],
          ),
        ),
      ),
    );
  }
}
