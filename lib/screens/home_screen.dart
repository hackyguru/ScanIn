import 'package:example/screens/scan_document.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'scandoc_fromgal.dart';
import 'view_document.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(DocIt());
  });
}

class DocIt extends StatelessWidget {
  static String route = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color primaryColor = Color(0xFF333333);
  Color secondaryColor = Color(0xFFf37121);

  Future<bool> _requestPermission() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void askPermission() async {
    await _requestPermission();
  }

  @override
  void initState() {
    super.initState();
    askPermission();
    _onRefresh();
    getData();
  }

  Future _onRefresh() async {
    imageDirectories = await getDirectoryNames();
    setState(() {});
  }

  void getData() {
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String folderName;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.orange,
          body: Stack(
            overflow: Overflow.clip,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(4294214946), Color(4292963586)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 160.4),
                child: Container(
                  alignment: Alignment.center,
                  height: 523,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color(4280033838),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, right: 150),
                        child: Text(
                          'Recent Documents',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "space"),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: getDirectoryNames(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: GridView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: imageDirectories.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0),
                                itemBuilder: (context, index) {
                                  folderName = imageDirectories[index]['path']
                                      .substring(
                                          imageDirectories[index]['path']
                                                  .lastIndexOf('/') +
                                              1,
                                          imageDirectories[index]['path']
                                                  .length -
                                              1);
                                  return GestureDetector(
                                    onTap: () {
                                      showLockScreen(
                                        context: context,
                                        correctString: '1234',
                                        onCompleted: (context, result) {
                                          // if you specify this callback,
                                          // you must close the screen yourself
                                          Navigator.of(context).maybePop();
                                        },
                                        onUnlocked: () {
                                          getDirectoryNames();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewDocument(
                                                dirPath: imageDirectories[index]
                                                    ['path'],
                                              ),
                                            ),
                                          ).whenComplete(() => () {
                                                print('Completed');
                                              });
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 320,
                                      width: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(4280824901),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.landscape,
                                              size: 90,
                                              color: Colors.orangeAccent[700],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 150,
                                                    height: 51,
                                                    child: Text(folderName,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Last Modified: ${imageDirectories[index]['modified'].day}-${imageDirectories[index]['modified'].month}-${imageDirectories[index]['modified'].year}',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130, left: 230),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ScanDocument()));
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Icon(
                    Icons.camera,
                    size: 40,
                    color: Color(4280033838),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130, left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SelectGal()));
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.photo_library,
                    size: 40,
                    color: Color(4280033838),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

var imageDirPaths = [];
var imageCount = 0;
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
        'count': imageCount,
      });
    }
    imageDirectories.sort((a, b) => a['modified'].compareTo(b['modified']));
    imageDirectories = imageDirectories.reversed.toList();
  });
  return imageDirectories;
}

List<Map<String, dynamic>> imageDirectories = [];
