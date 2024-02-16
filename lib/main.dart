import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokon_photo/save.dart';
import 'package:dokon_photo/sotuv_bolimi.dart';
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
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController maxsulotnomiEdit = TextEditingController();
  TextEditingController maxsulotsoniEdit = TextEditingController();
  TextEditingController maxsulotaslEdit = TextEditingController();
  TextEditingController maxsulotnarxiEdit = TextEditingController();
  CollectionReference maxsulotCollection =
  FirebaseFirestore.instance.collection("maxsulot");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Maxsulotlar"),
        actions: [
          MaterialButton(
            onPressed: () {
              setState(() {
                print("Yangilandi");
              });
            },
            child: Icon(Icons.refresh),)
        ],
      ),
      body: StreamBuilder(
          stream: maxsulotCollection.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onLongPress: () {
                          maxsulotCollection.doc(document.id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                "O'chirildi",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              )));
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      AddApp(
                                        textId: document.id,
                                        maxsulotnomiMain:
                                        document['maxsulotnomi'],
                                        maxsulotnarxiMain:
                                        document['maxsulotnarxi'],
                                        maxsulotsoniMain:
                                        document['maxsulotsoni'],
                                        maxsulotaslMain:
                                        document['maxsulotasl'],
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent[200],
                              borderRadius: BorderRadius.circular(15),
                              border:
                              Border.all(width: 3, color: Colors.black12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(document['image'] , height: 200, width: 100,),
                              Text(
                                "Maxsulot nomi : ${document['maxsulotnomi']}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Maxsulot soni : ${document['maxsulotsoni']}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Maxsulot asl narxi  : ${document['maxsulotasl']} so'm",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Maxsulot narxi : ${document['maxsulotnarxi']} so'm",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                        onPressed: () {
                                          showModalBottomSheet(context: context,
                                              builder: (context) {
                                                return SotuvApp(
                                                  nameMain: document['maxsulotnomi'],
                                                  maxsulotsoni: document['maxsulotsoni'],
                                                  maxsulotid: document.id,
                                                  holat: "Sotildi",);
                                              });
                                        },
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius
                                                  .circular(15)
                                          ),
                                          child: Text('Sotildi',
                                            style: TextStyle(fontSize: 20,
                                                fontWeight: FontWeight.bold),),
                                        )
                                    ),
                                  ),
                                  MaterialButton(
                                      onPressed: () {
                                        showModalBottomSheet(context: context,
                                            builder: (context) {
                                              return SotuvApp(
                                                nameMain: document['maxsulotnomi'],
                                                maxsulotsoni: document['maxsulotsoni'],
                                                maxsulotid: document.id,
                                                holat: "Qo'shildi",);
                                            });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                                15)
                                        ),
                                        child: Icon(Icons.add, size: 20,),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text("Malumot yo'q"));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddApp()))
              .then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
