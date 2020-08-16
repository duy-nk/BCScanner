import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:commons/commons.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.path);
  final myController = TextEditingController();
  final String path;

  Size _imageSize;
  List<TextElement> _elements = [];
  String recognizedTextSDT = "Searching ...";
  void _initializeVision() async {
    final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String patternSDT = "^0[0-9\s.-]{9,13}";

    RegExp regExSDT = RegExp(patternSDT);

    String locSDT = "";

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (regExSDT.hasMatch(line.text)) {
          locSDT += line.text + '\n';
          for (TextElement element in line.elements) {
            _elements.add(element);
          }
        }
      }
    }

    if (this.mounted) {
      setState(() {
        recognizedTextSDT = locSDT;
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  Future<void> saveContactInPhone() async {
    try {
      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;

        if (permission == PermissionStatus.granted) {
          Contact newContact = new Contact();
          newContact.givenName = myController.text;
          newContact.phones = [Item(label: "mobile", value: recognizedTextSDT)];
          await ContactsService.addContact(newContact);
          successDialog(context, "Add contact successfully!");
        } else {}
      } else {
        Contact newContact = new Contact();
        newContact.givenName = myController.text;
        newContact.phones = [Item(label: "mobile", value: recognizedTextSDT)];

        await ContactsService.addContact(newContact);
        successDialog(context, "Add contact successfully!");
      }
      print("object");
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        saveContactInPhone();
        Navigator.of(context).pop();
        // successDialog(context, "Add contact successfully!");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add to Contact"),
      content: Text("Are you sure to add this contact?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan business card',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _imageSize != null
          ? Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: double.maxFinite,
                    color: Colors.black,
                    child: CustomPaint(
                      foregroundPainter:
                          TextDetectorPainter(_imageSize, _elements),
                      child: AspectRatio(
                        aspectRatio: _imageSize.aspectRatio,
                        child: Image.file(
                          File(path),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Phone number:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            child: SingleChildScrollView(
                                child: Text(recognizedTextSDT)),
                          ),
                          /* FittedBox(
                            child: GestureDetector(
                              onTap: () {
                                showAlertDialog(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 25),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color(0xFFFFBD73),
                                ),
                                child: Row(children: <Widget>[
                                  Text("Add to contact",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                          ), */
                          /* TextField(
                            controller: myController,
                          ), */
                          TextFormField(
                            controller: myController,
                            decoration: InputDecoration(
                                labelText:
                                    'Save phone number here by enter the name'),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                  onPressed: () {
                                    showAlertDialog(context);
                                  },
                                  child: Text("Add to contact"),
                                  color: Color(0xFFFFBD73),
                                  textColor: Colors.black,
                                )),
                                SizedBox(width: 20),
                                Expanded(
                                    child: RaisedButton(
                                  onPressed: () {
                                    launch("tel://" + recognizedTextSDT);
                                  },
                                  child: Text("Call phone"),
                                  color: Color(0xFFFFBD73),
                                  textColor: Colors.black,
                                )),
                              ],
                            ),
                          )
                        ],
                      ),
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

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.green
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
