import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../model/coal.dart';
import '../model/company.dart';
import '../model/noncoal.dart';
import 'dashboard.dart';
import 'non_coal_entry_screen.dart';
import 'non_coal_update_screen.dart';

class NonCoalHistoryScreen extends StatefulWidget {
  final  QueryDocumentSnapshot<Object?> coalModel;

  const NonCoalHistoryScreen({Key? key, required this.coalModel})
      : super(key: key);

  @override
  _NonCoalHistoryScreenState createState() => _NonCoalHistoryScreenState();
}

class _NonCoalHistoryScreenState extends State<NonCoalHistoryScreen> {
  double _totalStock = 0.0;
  int _totalAmount = 0;
  bool? _process;
  int? _count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;

    FirebaseFirestore.instance
        .collection('noncoal')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lc"].toString().toLowerCase() ==
            widget.coalModel.get("lc").toString().toLowerCase()) {
          setState(() {
            _totalStock = double.parse((double.parse(_totalStock.toString()) +
                double.parse(doc["ton"])).toStringAsFixed(3));
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSingleItem( coal) => Container(
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
                        "Invoice",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        coal["invoice"],
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
                          .collection('noncoal')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          if(doc["lc"] == coal["lc"] && doc["invoice"] == coal["invoice"]){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NonCoalUpdateScreen(
                                      coalModel: coal,
                                    )));
                          }
                        }
                      });

                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('noncoal')
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
    FirebaseFirestore.instance.collection("noncoal");

    Widget _buildListView() {
      return StreamBuilder<QuerySnapshot>(
          stream: _collectionReference.orderBy("invoice", descending: true).snapshots().asBroadcastStream(),
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
        title: Text("LC Number ${widget.coalModel["lc"]}"),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "LC Number : ${widget.coalModel["lc"]}",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NonCoalEntryScreen(
                        coalModel: widget.coalModel,
                      )));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
