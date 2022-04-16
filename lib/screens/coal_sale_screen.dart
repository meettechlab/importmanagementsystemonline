import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/pdf_coal.dart';
import '../model/coal.dart';
import '../model/invoiceCoal.dart';
import '../model/stone.dart';
import 'coal_sale_entry_screen.dart';
import 'coal_sale_update_screen.dart';
import 'individual_lc_entry_screen.dart';

class CoalSaleScreen extends StatefulWidget {
  const CoalSaleScreen({Key? key}) : super(key: key);

  @override
  _CoalSaleScreenState createState() => _CoalSaleScreenState();
}

class _CoalSaleScreenState extends State<CoalSaleScreen> {
  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('coals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lc"].toString().toLowerCase() != "sale") {
          setState(() {
            _totalStock = (_totalStock + double.parse(doc["ton"]));
          });
        }else{
          setState(() {
            _totalStock = (_totalStock - double.parse(doc["ton"]));
            _totalAmount = (_totalAmount + double.parse(doc["debit"]));
          });
        }
      }
    });
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.blue,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoalSaleEntryScreen()));
            },
            label: 'Add Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        SpeedDialChild(
            child: Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            onTap: () {
              setState(() {
                generatePdf();
              });
            },
            label: 'Generated PDF',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Coal Sale List'),
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
                  "Total Sale : $_totalAmount TK",
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
      floatingActionButton: _getFAB(),
    );
  }


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("coals");

  Widget _buildListView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.snapshots().asBroadcastStream(),
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
                element["lc"].toString().toLowerCase() == "sale")
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

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
                      "Buyer Name",
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
                      "Buyer Contact",
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
                      "Payment Type",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      coal["paymentType"],
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
                      "Payment Info ( If needed )",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      coal["paymentInformation"],
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
                      "Rate",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      coal["rate"],
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
                      "Total Amount Sale",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      coal["totalPrice"],
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
                        .collection('coals')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["invoice"] == coal["invoice"] && doc["lc"] == "sale"){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CoalSaleUpdateScreen(
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
                        .collection('coals')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if( doc["invoice"] == coal["invoice"]&& doc["lc"] == "sale"){
                          setState(() {
                            doc.reference.delete();
                          });
                        }
                      }
                    });

                    FirebaseFirestore.instance
                        .collection('companies')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if( doc["id"] ==  "coalsale" + coal["invoice"]){
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

  void generatePdf() async {
    FirebaseFirestore.instance
        .collection('coals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["lc"].toString().toLowerCase() == "sale"){


          final _list = <CoalItem>[];
          _list.add(new CoalItem(
            doc["date"],
            doc["truckCount"],
            doc["truckNumber"],
            doc["port"],
            doc["supplierName"],
            doc["ton"],
            doc["rate"],
            doc["totalPrice"],
            doc["paymentType"],
            doc["paymentInformation"],
            doc["remarks"],
          ));


          final _docList = [];
          _docList.add(doc);

          final invoice = InvoiceCoal(_totalStock.toString(), _totalAmount.toString(), "sale", _list);
          final pdfFile =  PdfCoal.generate(invoice, true);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
