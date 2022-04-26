import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../model/company.dart';
import '../model/nonstone.dart';
import 'dashboard.dart';
import 'non_stone_entry_screen.dart';
import 'non_stone_update_screen.dart';

class NonStoneHistoryScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> lcModel;

  const NonStoneHistoryScreen({Key? key, required this.lcModel})
      : super(key: key);

  @override
  _NonStoneHistoryScreenState createState() =>
      _NonStoneHistoryScreenState();
}

class _NonStoneHistoryScreenState extends State<NonStoneHistoryScreen> {

  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  final lcOpenPriceEditingController = new TextEditingController();
  final dutyCostEditingController = new TextEditingController();
  final speedMoneyEditingController = new TextEditingController();
  final rateEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? _process;
  int? _count;
  bool disFAB = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
    FirebaseFirestore.instance
        .collection('nonstone')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lcNumber"].toString().toLowerCase() ==
            widget.lcModel.get("lcNumber").toString().toLowerCase()) {
          setState(() {
            _totalStock = double.parse((double.parse(_totalStock.toString()) +
                double.parse(doc["cft"])).toStringAsFixed(3));
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    Widget buildSingleItem( lc) => Container(
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
                    lc["date"],
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
                    lc["invoice"],
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
                    "Truck No",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    lc["truckCount"],
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
                    "Truck Plate Number",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    lc["truckNumber"],
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
                    lc["port"],
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
                    "Seller Name",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    lc["sellerName"],
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
                    "Seller Contact",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    lc["sellerContact"],
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
                    "CFT",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    lc["cft"],
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
                    lc["remarks"],
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
                          .collection('nonstone')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          if(doc["lcNumber"] == lc["lcNumber"] && doc["invoice"] == lc["invoice"]){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NonStoneUpdateScreen(
                                      lcModel: lc,
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
                          .collection('nonstone')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          if(doc["lcNumber"] == lc["lcNumber"] && doc["invoice"] == lc["invoice"]){
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
    FirebaseFirestore.instance.collection("nonstone");

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
                  element["lcNumber"].toString().toLowerCase() ==
                      widget.lcModel.get("lcNumber").toString().toLowerCase() )
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
        title: Text("LC Number ${widget.lcModel["lcNumber"]}"),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LC Number : ${widget.lcModel["lcNumber"]}",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  Text(
                    "Stock : $_totalStock CFT",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  Text(
                    "Total Balance : $_totalAmount TK",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Expanded(child: _buildListView()),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => NonStoneEntryScreen(lcModel: widget.lcModel)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
