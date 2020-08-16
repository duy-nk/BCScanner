import 'package:app/CameraBarCode.dart';
import 'package:app/CameraScreen.dart';
import 'package:app/CameraTextScreen.dart';
import 'package:app/ToDoScreen.dart';
import 'package:flutter/material.dart';
import 'package:app/CameraS.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFCFCFC),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFF242E66), Color(0xFF121733)]),
                  image: DecorationImage(
                      image: AssetImage("assets/task.png"),
                      fit: BoxFit.contain)),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text("Scan Your World",
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(width: 5),
            Icon(
              Icons.favorite,
              color: Colors.red,
              size: 17.0,
            )
          ]),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF242E66),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Text("- Always The Real Thing, Always Easy -",
                  style: TextStyle(
                      fontSize: 13.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white)),
            )
          ]),
          SizedBox(height: 10),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ToDoScreen();
                },
              ));
            },
            child: CardSelect(
                image: "assets/taskk.png",
                title: "Note",
                text:
                    "With Bcard, you can take notes about your work, study, necessary personal information or everything in your life and more."),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CameraScreen();
                },
              ));
            },
            child: CardSelect(
                image: "assets/reco.png",
                title: "Card Scanning",
                text:
                    "Nobody wants to type business card data into contacts. With these apps, your phone can do the heavy lifting for you."),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CameraS();
                },
              ));
            },
            child: CardSelect(
                image: "assets/barcode.png",
                title: "BarCode Scanning",
                text:
                    "With ML Kit's barcode scanning API, you can read data encoded using most standard barcode formats."),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CameraBarCode();
                },
              ));
            },
            child: CardSelect(
                image: "assets/qrcode.png",
                title: "QR Code Scanning",
                text:
                    "When using 2D formats such as QR code, you can encode structured data such as contact information or WiFi network credentials. "),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CameraTextScreen();
                },
              ));
            },
            child: CardSelect(
                image: "assets/cardscan.png",
                title: "Text recognition",
                text:
                    "They can also be used to automate data-entry tasks such as processing credit cards, receipts, and business cards."),
          ),
          SizedBox(height: 20)
        ])));
  }
}

class CardSelect extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const CardSelect({Key key, this.image, this.title, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
                height: 136,
                width: double.infinity,
                decoration: BoxDecoration(
                    /*  gradient: LinearGradient(
                  colors: 
                    [
                    Color(0xFFFFF176),
                   // Color(0xFFF9A825)
                   Colors.orangeAccent
                  ] 
                  ), */
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    //    color: Colors.grey.withOpacity(0.15)

                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 8),
                          blurRadius: 24,
                          color: Color(0xFFB7B7B7).withOpacity(.3))
                    ])),
            Image.asset(image),
            Positioned(
                left: 140,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  height: 136,
                  width: MediaQuery.of(context).size.width - 170,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5))),
                          child: Text(title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white)),
                        ),
                        Text(
                          text,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )
                      ]),
                ))
          ],
        ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2 - 40, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
