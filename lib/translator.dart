import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:signapp/camera.dart';

class Translator extends StatefulWidget {
  const Translator({super.key});

  @override
  State<Translator> createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  //VAR
  String? imgurl = "";
  final TextEditingController TranslateTextBox = TextEditingController();
  late FlutterTts flutterTts;

  //FUN
  initTts() {
    flutterTts = FlutterTts(); // create new object
    flutterTts.setLanguage("ar"); //set language to arabic
    _setAwaitOptions();
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _speak() async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.setPitch(0.8);
    //check before speack if text is there
    if (TranslateTextBox.text != null) {
      if (TranslateTextBox.text!.isNotEmpty) {
        await flutterTts.speak(TranslateTextBox.text!);
      }
    }
  }

  //INIT
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    initTts(); // init listen button
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            "مترجم الاشارة",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.brown,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ***** TEXT SECTION ***** //
          Container(
            height: 250,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: TranslateTextBox,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: "نص الترجمة...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (TranslateTextBox.text == "") {
                      print("لايوجد نص للترجمة !");
                    } else {
                      //Get The Document and return same text the url image
                      final docRef = FirebaseFirestore.instance
                          .collection("arabic_to_sign")
                          .doc("nBnlKQ7Hn8NRKRjq6k57");
                      docRef.get().then(
                        (res) {
                          if (res[TranslateTextBox.text].toString() == "") {
                            print("Error image");
                          } else {
                            setState(() {
                              imgurl = "";
                              imgurl = res[TranslateTextBox.text];
                              print(imgurl);
                            });
                          }
                        },
                        onError: (e) => print("Error completing: $e"),
                      );
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.translate,
                          size: 24,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "ترجم للإشارة",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      print(TranslateTextBox.text);
                      _speak();
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign_rounded,
                          size: 24,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "إستمع للترجمة",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ***** IMAGE SECTION ***** //
          Container(
            height: 230,
            margin:
                const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: imgurl == ""
                    ? Icon(
                        Icons.photo,
                        color: Colors.grey,
                        size: 100,
                      )
                    : Image.network(imgurl.toString())),
          ),
          // ********* BUTTONS ********* //
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 20.0,
            ),
            child: InkWell(
              onTap: () async {
                //CAMERA PAGE
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CameraPage()));
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "الترجمة المباشرة",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
