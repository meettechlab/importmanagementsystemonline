import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsystemonline/screens/arhive_single.dart';
import 'package:importmanagementsystemonline/screens/single_coal_lc_screen.dart';
import '../model/coal.dart';
import '../model/company.dart';
import '../model/stone.dart';
import 'coal_lc_create_screen.dart';
import 'dashboard.dart';

class ArchiveLC extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> archive;
  const ArchiveLC({Key? key, required this.archive}) : super(key: key);

  @override
  _ArchiveLCState createState() => _ArchiveLCState();
}

class _ArchiveLCState extends State<ArchiveLC> {
  double _totalStock = 0.0;
  int _totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculate();
  }

  void calculate() async {
    FirebaseFirestore.instance
        .collection('coalarchive')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["archiveName"].toString().toLowerCase()==widget.archive["archiveName"].toString().toLowerCase()){
          setState(() {
            _totalStock = double.parse((_totalStock + double.parse(doc["ton"])).toStringAsFixed(3));
            _totalAmount = (_totalAmount + double.parse(doc["credit"])).floor();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Archive Coal LC List'),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Stock : $_totalStock Ton",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Total Purchase : $_totalAmount TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Expanded(child: _buildListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CoalLCCreateScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("coalarchive");

  Widget _buildListView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.orderBy("date", descending: true).snapshots().asBroadcastStream(),
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
                element["invoice"]
                    .toString()
                    .toLowerCase()
                    =="1" &&  element["archiveName"].toString()==widget.archive["archiveName"])
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget buildSingleItem(coal) => InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveSingle(coalModel: coal)));
    },
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Date",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["date"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "LC",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["lc"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Port",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["port"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Supplier Name",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["supplierName"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            IconButton(
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('coalarchive')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if(doc["lc"] == coal["lc"]){
                      setState(() {
                        doc.reference.delete();
                      });
                    }
                  }
                });

                // FirebaseFirestore.instance
                //     .collection('companies')
                //     .get()
                //     .then((QuerySnapshot querySnapshot) {
                //   for (var doc in querySnapshot.docs) {
                //     if(doc["id"] == "coalstock" + coal["lc"]){
                //       setState(() {
                //         doc.reference.delete();
                //       });
                //     }
                //   }
                // });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
