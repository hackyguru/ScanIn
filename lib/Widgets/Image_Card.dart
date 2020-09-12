import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../Utilities/constants.dart';
import '../Utilities/cropper.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({this.imageFile, this.imageFileEditCallback});

  final File imageFile;
  final Function imageFileEditCallback;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: primaryColor,
          child: FocusedMenuHolder(
            menuWidth: size.width * 0.44,
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      elevation: 20,
                      backgroundColor: primaryColor,
                      child: Container(
                        width: size.width * 0.1,
                        child: Image.file(
                          imageFile,
                          scale: 2.0,
                        ),
                      ),
                    );
                  });
            },
            menuItems: [
              FocusedMenuItem(
                title: Text(
                  'Crop',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  Cropper cropper = Cropper();
                  var image = await cropper.cropImage(imageFile);
                  File temp = File(imageFile.path
                          .substring(0, imageFile.path.lastIndexOf(".")) +
                      "c.jpg");
                  imageFile.deleteSync();
                  if (image != null) {
                    image.copy(temp.path);
                  }
                  imageFileEditCallback();
                },
                trailingIcon: Icon(
                  Icons.crop,
                  color: Colors.black,
                ),
              ),
              FocusedMenuItem(
                  title: Text('Delete'),
                  trailingIcon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          title: Text('Delete'),
                          content: Text('Do you really want to delete image?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            FlatButton(
                              onPressed: () {
                                imageFile.deleteSync();
                                imageFileEditCallback();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.redAccent),
            ],
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  imageFile,
                  scale: 2.0,
                  fit: BoxFit.fill,
                ),
              ),
              height: size.height * 0.57,
              width: size.width * 0.47,
            ),
          ),
        ),
      ),
    );
  }
}
