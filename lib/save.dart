
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class AddApp extends StatefulWidget {
  final String? textId;
  final String? maxsulotnomiMain;
  final String? maxsulotsoniMain;
  final String? maxsulotaslMain;
  final String? maxsulotnarxiMain;
  const AddApp({super.key , this.textId, this.maxsulotnomiMain, this.maxsulotsoniMain, this.maxsulotaslMain, this.maxsulotnarxiMain});
  @override
  State<AddApp> createState() => _MyAppState();
}

class _MyAppState extends State<AddApp> {
  TextEditingController maxsulotnomi = TextEditingController();
  TextEditingController maxsulotnarxi = TextEditingController();
  TextEditingController maxsulotasl = TextEditingController();
  TextEditingController maxsulotsoni = TextEditingController();
  final CollectionReference maxsulotCollection = FirebaseFirestore.instance.collection("maxsulot");
  String imagelink ='';
  String ImgPath = "";
  CollectionReference instance = FirebaseFirestore.instance.collection("images");
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  saveLink(Reference ref) async {
    var link = await ref.getDownloadURL();
    imagelink = link;
  }

  uploadPhoto() async{
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final ImagePicker imagePicker = ImagePicker();
    XFile? xFile;
    PermissionStatus permissionStatus = await Permission.photos.request();
    if(permissionStatus.isGranted){
      try {
        xFile = await imagePicker.pickImage(source: ImageSource.gallery);
        File file = File(xFile?.path??"");
        Reference ref = firebaseStorage.ref("image").child("${file.path.split("/").last}");
        print(ref);
        UploadTask snapshot = ref.putFile(file);
        snapshot.then((value) async{
          if(value.state == TaskState.success){
            saveLink(ref);
            ImgPath = file.path.split("/").last;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Yuklandi ✔")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
          }
          });
      } catch(e){
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.textId != null){
      maxsulotnomi = TextEditingController(text: widget.maxsulotnomiMain);
      maxsulotsoni = TextEditingController(text: widget.maxsulotsoniMain);
      maxsulotasl = TextEditingController(text: widget.maxsulotaslMain);
      maxsulotnarxi = TextEditingController(text: widget.maxsulotnarxiMain);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: maxsulotnomi,
                decoration: InputDecoration(
                    label: Text("Maxsulot nomi"), border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: maxsulotsoni,
                decoration: InputDecoration(
                    label: Text("Maxsulot soni"), border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: maxsulotasl,
                decoration: InputDecoration(
                    label: Text("Maxsulot asl narxi"), border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: maxsulotnarxi,
                decoration: InputDecoration(
                    label: Text("Maxsulot narxi"), border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    uploadPhoto();
                  });
                },
                child: Text("Rasm yuklash"),
                color: Colors.green,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    if(widget.textId != null){
                      update();

                    } else {
                      print("ADD funksiyasi ishladi");
                      add();
                    }
                  });
                },
                child: Text("Saqlash"),
                color: Colors.blue,
              ),
            ),

          ]),
        ],
      ),
    );
  }
  add(){
    if (maxsulotasl.text.length != 0 && maxsulotnarxi.text.length != 0 && maxsulotsoni.text.length != 0 && maxsulotnomi.text.length != 0) {
      if(imagelink != ""){
        Map<String, dynamic> pupil = {
          "image": imagelink,
          "path":ImgPath,
          "maxsulotnomi": maxsulotnomi.text,
          "maxsulotsoni": maxsulotsoni.text,
          "maxsulotasl": maxsulotasl.text,
          "maxsulotnarxi": maxsulotnarxi.text,
        };
        maxsulotCollection.add(pupil);
      } else if(imagelink == "") {
        imagelink == "";
        Map<String, dynamic> pupil = {
          "image": imagelink,
          "maxsulotnomi": maxsulotnomi.text,
          "maxsulotsoni": maxsulotsoni.text,
          "maxsulotasl": maxsulotasl.text,
          "maxsulotnarxi": maxsulotnarxi.text,
        };
        maxsulotCollection.add(pupil);
      }
      maxsulotnarxi.clear();
      maxsulotasl.clear();
      maxsulotsoni.clear();
      maxsulotnomi.clear();
      imagelink = "";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Saqlandi",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent,
          content: Text("Bosh joylarni to'ldiring", style: TextStyle(color: Colors.white, fontSize: 30),
          )));
    }
  }
  update(){
    if (maxsulotasl.text.length != 0 && maxsulotnarxi.text.length != 0 && maxsulotsoni.text.length != 0 && maxsulotnomi.text.length != 0) {
      if(imagelink == ""){
        maxsulotCollection.doc(widget.textId).update({
          "maxsulotnomi": maxsulotnomi.text,
          "maxsulotsoni": maxsulotsoni.text,
          "maxsulotasl": maxsulotasl.text,
          "maxsulotnarxi": maxsulotnarxi.text,
        });
      } else if(imagelink != ""){
        maxsulotCollection.doc(widget.textId).update({
          "image": imagelink,
          "maxsulotnomi": maxsulotnomi.text,
          "maxsulotsoni": maxsulotsoni.text,
          "maxsulotasl": maxsulotasl.text,
          "maxsulotnarxi": maxsulotnarxi.text,
        });
      }
      maxsulotnarxi.clear();
      maxsulotasl.clear();
      maxsulotsoni.clear();
      maxsulotnomi.clear();
      imagelink = "";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Ozgartirildi",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent,
          content: Text("Bosh joylarni to'ldiring", style: TextStyle(color: Colors.white, fontSize: 30),
          )));
    }
  }
  delatePh(document)async{
    try {
      Reference ref = firebaseStorage.ref(
          'image/${document['path']}');
      await ref.delete();
      await instance.doc(document.id).delete();
    } catch (e) {
      print("Xatolik");
    }
  }
}
