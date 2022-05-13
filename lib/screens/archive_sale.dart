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
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';

class ArchiveSale extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> archive;
  const ArchiveSale({Key? key,required this.archive}) : super(key: key);

  @override
  _ArchiveSaleState createState() => _ArchiveSaleState();
}

class _ArchiveSaleState extends State<ArchiveSale> {
  double _totalStock = 0.0;
  int _totalAmount = 0;

  final TextEditingController searchController = TextEditingController();
  bool search = false;
  final TextEditingController yearSearchController = TextEditingController();
  bool yearSearch = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('coalarchive')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["archiveName"].toString().toLowerCase()==widget.archive["archiveName"].toString().toLowerCase()) {
          setState(() {
            _totalStock = double.parse((_totalStock + double.parse(doc["ton"])).toStringAsFixed(3));
            _totalAmount = (_totalAmount + double.parse(doc["debit"])).floor();
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final nameSearchField = Container(
        width: MediaQuery.of(context).size.width / 5,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: searchController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("name cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              searchController.text = value!;
            },
            onChanged: (value) {
              setState(() {
                search = true;
                yearSearchController.clear();
              });
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Search Company',
              labelStyle: TextStyle(color: Colors.blue),
              floatingLabelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final yearSearchField = Container(
        width: MediaQuery.of(context).size.width / 5,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: yearSearchController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("year cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              yearSearchController.text = value!;
            },
            onChanged: (value) {
              setState(() {
                yearSearch = true;
                searchController.clear();
              });
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Search Year',
              labelStyle: TextStyle(color: Colors.blue),
              floatingLabelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Archive Coal Sale List'),
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
                  "Total Stock : $_totalStock Ton",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),

                nameSearchField,
                yearSearchField,
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
          Expanded(child: (search) ? _searchBuilder() : (yearSearch)? _yearSearchBuilder() : _buildListView()),
        ],
      ),
    );
  }


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("coalarchive");

  Widget _yearSearchBuilder() {
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
                    element["year"].contains(yearSearchController.text) && element["archiveName"].toString().toLowerCase()==widget.archive["archiveName"])
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget _searchBuilder() {
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
                    .where((QueryDocumentSnapshot<Object?> element) => element["archiveName"].toString().toLowerCase()==widget.archive["archiveName"].toString().toLowerCase()&&
                    element["supplierName"].toString().toLowerCase().contains(searchController.text))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

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
                element["lc"].toString().toLowerCase() == "sale" && element["archiveName"].toString().toLowerCase()==widget.archive["archiveName"].toString().toLowerCase())
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
                    .collection('coalarchive')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if( doc["docID"] == coal["docID"]){
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
                //     if( doc["id"] ==  "coalsale" + coal["invoice"]){
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
            ),
          ],
        ),
      ),
    ),
  );
}
