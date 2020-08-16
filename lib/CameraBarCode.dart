import 'dart:io';

import 'package:app/BarCode.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


List<CameraDescription> camerass = [];
class CameraBarCode extends StatefulWidget {
  @override
  _CameraBarCodeState createState() => _CameraBarCodeState();
}

class _CameraBarCodeState extends State<CameraBarCode> {
  CameraController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(camerass[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');
    print("Formatted: $formattedDateTime");

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    if (_controller.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }

    try {
      await _controller.takePicture(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Scan', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: <Widget>[
                CameraPreview(_controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child:
                     RaisedButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text("Click"),
                      onPressed: () async {
                        await _takePicture().then((String path) {
                          if (path != null) {
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BarCode(path),
                              ),
                            );
                          }
                        });
                        
                      },
                    ), 
                  
                  ),
                ),
                
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}