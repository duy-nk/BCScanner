import 'package:app/db/database_provider.dart';
import 'package:app/model/Todo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:commons/commons.dart';

class DetailTextScreenB extends StatefulWidget {
  final String imagePath;
  DetailTextScreenB(this.imagePath);

  @override
  _DetailTextScreenBState createState() =>
      new _DetailTextScreenBState(imagePath);
}

class _DetailTextScreenBState extends State<DetailTextScreenB> {
  _DetailTextScreenBState(this.pathh);
  Todo todo;
  final descriptionTextBController = TextEditingController();
  final String pathh;
// obtain shared preferences

  final titleAvailableTextController = TextEditingController();
  Size _imageSize;
  List<TextElement> _elements = [];
  String recognized = "Loading ...";
  void _initializeVision() async {
    final File imageFile = File(pathh);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String word = "No text found";

    for (TextBlock blockkk in visionText.blocks) {
      for (TextLine lineee in blockkk.lines) {
        word += lineee.text + '\n';
      }
    }

    if (this.mounted) {
      setState(() {
        recognized = word;
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
    if (todo != null) {
      descriptionTextBController.text = todo.content;
    }
  }

  @override
  void dispose() {
    super.dispose();
    descriptionTextBController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan document',
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
                          File(pathh),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 1,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(),
                          SizedBox(height: 20),
                          /* Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Document:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), */
                          Container(
                            height: 150,
                            child: SingleChildScrollView(
                              child: SelectableText(
                                recognized,
                                toolbarOptions: ToolbarOptions(
                                  copy: true,
                                  selectAll: true,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: descriptionTextBController,
                            decoration: InputDecoration(
                                labelText:
                                    'You can save text here by enter the name'),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                  onPressed: () async {
                                    _saveTodo(descriptionTextBController.text,
                                        recognized);
                                    successDialog(
                                        context, "Save note successfully!");
                                    setState(() {});
                                  },
                                  child: Text("Save note"),
                                  color: Color(0xFFFFBD73),
                                  textColor: Colors.black,
                                )),
                                SizedBox(width: 20),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.share),
                                    onPressed: () {
                                      Share.share(recognized);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /* RaisedButton(
                            onPressed: () async {
                              _saveTodo(
                                  descriptionTextBController.text, recognized);
                              successDialog(context, "Save note successfully!");
                              setState(() {});
                            },
                            child: Text("Save note to the Todo list"),
                            color: Color(0xFFFFBD73),
                            textColor: Colors.black,
                          ) */
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

  _saveTodo(String title, String content) async {
    if (todo == null) {
      DatabaseHelper.instance.insertTodo(
          Todo(title: descriptionTextBController.text, content: recognized));
      Navigator.pop(context, "Your todo has been saved.");
    } else {
      await DatabaseHelper.instance
          .updateTodo(Todo(id: todo.id, title: title, content: content));
      Navigator.pop(context);
    }
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
