import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsystemonline/screens/archive_lc.dart';
import 'package:importmanagementsystemonline/screens/archive_sale.dart';
import 'package:importmanagementsystemonline/screens/single_company_screen.dart';


import '../model/company.dart';
import 'create_company_screen.dart';
import 'dashboard.dart';

class Archive extends StatefulWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Coal Archive'
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Text(
                "Dashboard",
                style: TextStyle(
                    color: Colors.white
                ),
              )
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("coalarchive");

  Widget _buildListView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.orderBy("date" , descending: true).snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                element["archive"].toString()== "1")
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }


  Widget buildSingleItem(coal) => InkWell(
    onTap: (){
      if(coal["archiveName"].toString().toLowerCase().contains("sale")){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveSale(archive: coal,)));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveLC(archive: coal,)));
      }
    },
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Text(
              coal["archiveName"],
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context)=>AlertDialog(
                      title: Text("Confirm"),
                      content: Text("Do you want to delete it?"),
                      actions: [
                        IconButton(
                            icon: new Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        IconButton(
                            icon: new Icon(Icons.delete),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('coalarchive')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                for (var doc in querySnapshot.docs) {
                                  if(doc["archiveName"] == coal["archiveName"]){
                                    setState(() {
                                      doc.reference.delete();
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Archive()));
                                    });
                                  }
                                }
                              });
                            })
                      ],
                    )
                );
              },
              icon: Icon(Icons.delete, color: Colors.red,),
            )
          ],
        ),
      ),
    ),
  );
}
