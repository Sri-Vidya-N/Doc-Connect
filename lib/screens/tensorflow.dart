import 'dart:io';
import 'package:DocConnect/mainPage.dart';
import 'package:DocConnect/screens/MyAlert.dart';
import 'package:DocConnect/screens/exploreList.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tflite/tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:DocConnect/model/cardModel.dart';

import 'MyAlert.dart';
import 'homePage.dart';

class Tensorflow extends StatefulWidget {
  @override
  _TensorflowState createState() => _TensorflowState();
}

class _TensorflowState extends State<Tensorflow> {
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    setState(() {
      _loading = false;
      _outputs = output;
    });

    if (_outputs[0]["label"].substring(1) != " NORMAL") {
      showAlertDialog(context, _outputs[0]["label"].substring(1));
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Predicting the Infection",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.blue[500],
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loading
                ? Container(
                    height: 300,
                    width: 300,
                  )
                : Container(
                    margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image == null ? Container() : Image.file(_image),
                        SizedBox(
                          height: 20,
                        ),
                        _image == null
                            ? Container()
                            : _outputs != null
                                ? Text(
                                    _outputs[0]["label"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                // ? createDialog(context, _outputs[0]["label"])
                                : Container(child: Text("")) != null
                                    ? Text(
                                        _outputs[0]["label"].substring(1),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      )
                                    : Container(child: Text("")),
                      ],
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FloatingActionButton(
              tooltip: 'Pick Image',
              onPressed: pickImage,
              child: Icon(
                Icons.add_a_photo,
                size: 20,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue[400],
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String output) {
  // Create button
  Widget homeButton = FlatButton(
    child: Text("Home Page"),
    onPressed: () {
      Navigator.pushReplacement(
          context,
          PageTransition(
            child: MainPage(),
            type: PageTransitionType.bottomToTop,
          ));
    },
  );

  Widget doctorButton = FlatButton(
    child: Text("Consult Doctor"),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExploreList(
                  type: cards[0].doctor,
                )),
      );
    },
  );
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Results!"),
    content: Text("$output has been detected!"),
    actions: [
      homeButton,
      doctorButton,
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
