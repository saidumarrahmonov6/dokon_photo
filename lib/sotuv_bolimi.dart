import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class SotuvApp extends StatefulWidget {
  final String nameMain;
  final String maxsulotsoni;
  final String maxsulotid;
  final String holat;
  const SotuvApp({super.key, required this.nameMain, required this.maxsulotsoni, required this.maxsulotid, required this.holat});

  @override
  State<SotuvApp> createState() => _SotuvAppState();
}

class _SotuvAppState extends State<SotuvApp> {
  TextEditingController sotildi = TextEditingController();
  final CollectionReference maxsulotCollection = FirebaseFirestore.instance.collection("maxsulot");
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Text(widget.nameMain , style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),),
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: TextField(
            controller: sotildi,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Nechta ${widget.holat}"),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
          color: Colors.green,
            borderRadius: BorderRadius.circular(15)
          ),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsetsDirectional.all(15),
          child: MaterialButton(
            onPressed: (){
              if(widget.holat == "Sotildi" && sotildi.text != ""){
                  int son1 = int.parse(widget.maxsulotsoni);
                  int son2 = int.parse(sotildi.text);
                  int son3 = son1-son2;
                  maxsulotCollection.doc(widget.maxsulotid).update({'maxsulotsoni':son3.toString(),});
                  Navigator.pop(context);
                } else if(widget.holat == "Qo'shildi" && sotildi.text != ""){
                int son1 = int.parse(widget.maxsulotsoni);
                int son2 = int.parse(sotildi.text);
                int son3 = son1+son2;
                maxsulotCollection.doc(widget.maxsulotid).update({'maxsulotsoni':son3.toString(),});
                Navigator.pop(context);
              }
            },
            child: Text(widget.holat),
          ),
        ),
      ],
    );
  }
}
