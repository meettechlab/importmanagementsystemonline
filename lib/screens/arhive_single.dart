import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsystemonline/screens/single_coal_entry_screen.dart';
import 'package:importmanagementsystemonline/screens/single_coal_update_screen.dart';
import 'package:intl/intl.dart';

import '../api/pdf_coal.dart';
import '../model/coal.dart';
import '../model/company.dart';
import '../model/invoiceCoal.dart';
import 'dashboard.dart';

class ArchiveSingle extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> coalModel;

  const ArchiveSingle({Key? key, required this.coalModel})
      : super(key: key);

  @override
  _ArchiveSingleState createState() => _ArchiveSingleState();
}

class _ArchiveSingleState extends State<ArchiveSingle> {
  double _totalStock = 0.0;
  int _totalAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    FirebaseFirestore.instance
        .collection('coalarchive')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lc"].toString().toLowerCase() ==
            widget.coalModel.get("lc").toString().toLowerCase()) {
          setState(() {
            _totalStock = double.parse((double.parse(_totalStock.toString()) +
                double.parse(doc["ton"])).toStringAsFixed(3));
          });


          final _docList = [];
          _docList.add(doc);

          if (double.parse(_docList.last["totalPrice"]) > 0) {
            _totalAmount = double.parse(_docList.last["totalPrice"]).floor();
          }
        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSingleItem(coal) => Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  Text(
                    "Truck Count",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    coal["truckCount"],
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
                    "Truck Number",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    coal["truckNumber"],
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
              Column(
                children: [
                  Text(
                    "Supplier Contact",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    coal["contact"],
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
                    "Ton",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    coal["ton"],
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
                    "Remarks",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    coal["remarks"],
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                width: 70,
              ),
 IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('coalarchive')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                      if(doc["lc"] == coal["lc"] && doc["invoice"] == coal["invoice"]){
                        setState(() {
                          doc.reference.delete();
                        });
                      }
                    }
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );

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
                  element["lc"].toString().toLowerCase() ==
                      widget.coalModel.get("lc").toString().toLowerCase() )
                      .map((QueryDocumentSnapshot<Object?> data) {
                    return buildSingleItem(data);
                  })
                ],
              );
            }
          });
    }



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LC Number ${widget.coalModel.get("lc")}"),
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
      body: Container(
        padding: EdgeInsets.all(20),
        child:  Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LC Number : ${widget.coalModel.get("lc")}",
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                  Text(
                    "Stock : $_totalStock Ton",
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                  Text(
                    "Total Cost : $_totalAmount TK",
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              Expanded(child: _buildListView()),
            ],
          ),
        ),
      );
  }

}
