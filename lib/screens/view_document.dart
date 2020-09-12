import 'dart:io';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:example/Utilities/constants.dart';
import 'package:example/Utilities/file_operations.dart';
import 'package:example/Widgets/Image_Card.dart';
import 'package:example/screens/home_screen.dart';
import 'package:example/screens/pdf_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class ViewDocument extends StatefulWidget {
  static String route = "ViewDocument";

  ViewDocument({this.dirPath});

  final String dirPath;

  @override
  _ViewDocumentState createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  File imageFile;
  Future<bool> _onBackPressed() async {
    return (Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home())) ??
        false);
  }

  void getImages() {
    imageFilesPath = [];
    imageFilesWithDate = [];

    Directory(dirName)
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      List<String> temp = entity.path.split(" ");
      imageFilesWithDate.add({
        "file": entity,
        "creationDate": DateTime.parse("${temp[3]} ${temp[4]}")
      });

      setState(() {
        imageFilesWithDate
            .sort((a, b) => a["creationDate"].compareTo(b["creationDate"]));
        for (var image in imageFilesWithDate) {
          if (!imageFilesPath.contains(image['file'].path))
            imageFilesPath.add(image["file"].path);
        }
      });
    });
  }

  void imageEditCallback() {
    getImages();
  }

  Future<void> displayDialog(BuildContext context) async {
    String displayText;
    (statusSuccess)
        ? displayText = "Success. File stored in the OpenScan folder."
        : displayText = "Failed to generate pdf. Try Again.";
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(displayText)),
    );
  }

  @override
  void initState() {
    super.initState();
    fileOperations = FileOperations();
    dirName = widget.dirPath;
    getImages();
    fileName =
        dirName.substring(dirName.lastIndexOf("/") + 1, dirName.length - 1);
  }

  Future getDirectoryNames() async {
    Directory appDir = await getExternalStorageDirectory();
    Directory appDirPath = Directory("${appDir.path}");
    appDirPath
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      String path = entity.path;
      if (!imageDirPaths.contains(path) &&
          path !=
              '/storage/emulated/0/Android/data/com.cybrin.scanin/files/Pictures') {
        imageDirPaths.add(path);
        Directory(path)
            .list(recursive: false, followLinks: false)
            .listen((FileSystemEntity entity) {
          imageCount++;
        });
        FileStat fileStat = FileStat.statSync(path);
        imageDirectories.add({
          'path': path,
          'modified': fileStat.modified,
          'size': fileStat.size,
          'count': imageCount
        });
      }
      imageDirectories.sort((a, b) => a['modified'].compareTo(b['modified']));
      imageDirectories = imageDirectories.reversed.toList();
    });
    return imageDirectories;
  }

  Future<void> openCamera() async {
    imageFile = File(await EdgeDetection.detectEdge);
  }

  var imageDirPaths = [];
  var imageCount = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: primaryColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DocIt()),
                      (route) => false);
                },
              ),
              title: RichText(
                text: TextSpan(
                  text: 'View ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: 'Document',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 100, left: 10),
                    child: FutureBuilder(
                        future: getDirectoryNames(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                folderName = imageDirectories[index]['path']
                                    .substring(
                                        imageDirectories[index]['path']
                                                .lastIndexOf('/') +
                                            1,
                                        imageDirectories[index]['path'].length -
                                            1);
                                return Align(
                                  alignment: index.isEven
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Container(
                                    width: 170,
                                    height: 130,
                                    child: Text(
                                      folderName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                );
                              });
                        })),  
                Padding(
                  padding: EdgeInsets.only(top: 230, left: 15),
                  child: GestureDetector(
                    onTap: () async {
                      statusSuccess = await fileOperations.saveToAppDirectory(
                        context: context,
                        fileName: fileName,
                        images: imageFilesWithDate,
                      );
                      Directory storedDirectory =
                          await getApplicationDocumentsDirectory();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(
                            path: '${storedDirectory.path}/$fileName.pdf',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white),
                      child: Text(
                        "View PDF",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: EdgeInsets.only(left: 185, bottom: 150),
                    child: Container(
                      height: 570,
                      width: 470,
                      child: FutureBuilder(
                          future: getDirectoryNames(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                              dragStartBehavior: DragStartBehavior.start,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  ((imageFilesWithDate.length) / 2).round(),
                              itemBuilder: (context, index) {
                                folderName = imageDirectories[index]['path']
                                    .substring(
                                        imageDirectories[index]['path']
                                                .lastIndexOf('/') +
                                            1,
                                        imageDirectories[index]['path'].length -
                                            1);
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      ImageCard(
                                        imageFile: File(
                                            imageFilesWithDate[index * 2]
                                                    ["file"]
                                                .path),
                                        imageFileEditCallback:
                                            imageEditCallback,
                                      ),
                                      if (index * 2 + 1 <
                                          imageFilesWithDate.length)
                                        ImageCard(
                                          imageFile: File(
                                              imageFilesWithDate[index * 2 + 1]
                                                      ["file"]
                                                  .path),
                                          imageFileEditCallback:
                                              imageEditCallback,
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.45,
                    minChildSize: 0.45,
                    maxChildSize: 0.45,
                    builder: (BuildContext context, myscrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        child: ListView.builder(
                          controller: myscrollController,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                padding: EdgeInsets.only(top: 30),
                                child: Column(children: <Widget>[
                                  Container(
                                    width: 500,
                                    height: 170,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    10),
                                                              ),
                                                            ),
                                                            title: Text(
                                                                'Share as PDF'),
                                                            content: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                fileName =
                                                                    '$value ScanIn';
                                                              },
                                                              controller: TextEditingController(
                                                                  text: fileName
                                                                      .substring(
                                                                          8,
                                                                          fileName
                                                                              .length)),
                                                              cursorColor:
                                                                  secondaryColor,
                                                              textCapitalization:
                                                                  TextCapitalization
                                                                      .words,
                                                              decoration:
                                                                  InputDecoration(
                                                                prefixStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                suffixText:
                                                                    ' ScanIn.pdf',
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                secondaryColor)),
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              FlatButton(
                                                                onPressed:
                                                                    () async {
                                                                  statusSuccess =
                                                                      await fileOperations
                                                                          .saveToAppDirectory(
                                                                    context:
                                                                        context,
                                                                    fileName:
                                                                        fileName,
                                                                    images:
                                                                        imageFilesWithDate,
                                                                  );
                                                                  Directory
                                                                      storedDirectory =
                                                                      await getApplicationDocumentsDirectory();
                                                                  ShareExtend.share(
                                                                      '${storedDirectory.path}/$fileName.pdf',
                                                                      'file');
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Share',
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .picture_as_pdf,
                                                                size: 34,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              Text(
                                                                "Share PDF",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ))),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    var image =
                                                        await openCamera();

                                                    await fileOperations
                                                        .saveImage(
                                                      image: imageFile,
                                                      i: imageFilesWithDate
                                                              .length +
                                                          1,
                                                      dirName: dirName,
                                                    );

                                                    getImages();
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.add,
                                                                size: 34,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              Text(
                                                                "Add a Photo",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ))),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    10),
                                                              ),
                                                            ),
                                                            title: Text(
                                                                'Save To Device'),
                                                            content: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                fileName =
                                                                    '$value ScanIn';
                                                              },
                                                              controller: TextEditingController(
                                                                  text: fileName
                                                                      .substring(
                                                                          8,
                                                                          fileName
                                                                              .length)),
                                                              cursorColor:
                                                                  secondaryColor,
                                                              textCapitalization:
                                                                  TextCapitalization
                                                                      .words,
                                                              decoration:
                                                                  InputDecoration(
                                                                prefixStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                suffixText:
                                                                    ' ScanIn.pdf',
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                secondaryColor)),
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              FlatButton(
                                                                onPressed:
                                                                    () async {
                                                                  String
                                                                      savedDirectory;
                                                                  savedDirectory =
                                                                      await fileOperations
                                                                          .saveToDevice(
                                                                    context:
                                                                        context,
                                                                    fileName:
                                                                        fileName,
                                                                    images:
                                                                        imageFilesWithDate,
                                                                  );
                                                                  String
                                                                      displayText;
                                                                  (savedDirectory !=
                                                                          null)
                                                                      ? displayText =
                                                                          "Saved at $savedDirectory"
                                                                      : displayText =
                                                                          "Failed To Save PDF. Try Again.";

                                                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                                                      behavior: SnackBarBehavior.floating,
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                      backgroundColor: primaryColor,
                                                                      duration: Duration(seconds: 1),
                                                                      content: Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height:
                                                                            20,
                                                                        width: size.width *
                                                                            0.3,
                                                                        child:
                                                                            Text(
                                                                          displayText,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12),
                                                                        ),
                                                                      )));

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Save',
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .file_download,
                                                                size: 34,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                " Save to Device",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ))),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    ShareExtend.shareMultiple(
                                                        imageFilesPath, 'file');
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.image,
                                                                size: 34,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              Text(
                                                                "Share as Image",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ))),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            'Delete',
                                                          ),
                                                          content: Text(
                                                              'Do you really want to delete file?'),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                Directory(
                                                                        dirName)
                                                                    .deleteSync(
                                                                        recursive:
                                                                            true);
                                                                Navigator.pushAndRemoveUntil(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                DocIt()),
                                                                    (route) =>
                                                                        false);
                                                              },
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.delete,
                                                                size: 40,
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                              Text(
                                                                "Delete All",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.all(24),
                                  )
                                ]));
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}

String folderName;
final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

List<Map<String, dynamic>> imageFilesWithDate = [];
List<String> imageFilesPath = [];

FileOperations fileOperations;

String dirName;

String fileName;

bool statusSuccess;
List<Map<String, dynamic>> imageDirectories = [];