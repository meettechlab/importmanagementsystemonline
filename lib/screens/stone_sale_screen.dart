import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsystemonline/screens/stone_update_screen.dart';

import '../api/pdf_invoice_api_stone_purchase.dart';
import '../api/pdf_stone_sale.dart';
import '../model/invoiceStoneSale.dart';
import '../model/lc.dart';
import '../model/stone.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';
import 'new_stone_sale_screen.dart';

class StoneSaleScreen extends StatefulWidget {
  const StoneSaleScreen({Key? key}) : super(key: key);

  @override
  _StoneSaleScreenState createState() => _StoneSaleScreenState();
}

class _StoneSaleScreenState extends State<StoneSaleScreen> {
  double _totalStockTamabil = 0.0;
  int _totalAmountTamabil = 0;
  double _totalStockShutarkandi = 0.0;
  int _totalAmountShutarkandi = 0;
  final TextEditingController searchController = TextEditingController();
  bool search = false;
  final TextEditingController yearSearchController = TextEditingController();
  bool yearSearch = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('lcs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["port"].toString().toLowerCase()=="tamabil"){
          setState(() {
            _totalStockTamabil =
                double.parse( (double.parse(_totalStockTamabil.toString()) + double.parse(doc["cft"])).toStringAsFixed(3));
          });
        }else if(doc["port"].toString().toLowerCase()=="shutarkandi"){
          setState(() {
            _totalStockShutarkandi =
                double.parse( (double.parse(_totalStockShutarkandi.toString()) + double.parse(doc["cft"])).toStringAsFixed(3));
          });
        }

      }
    });
    FirebaseFirestore.instance
        .collection('stones')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["port"].toString().toLowerCase()=="tamabil"){
          setState(() {
            _totalStockTamabil =
                double.parse(    (double.parse(_totalStockTamabil.toString()) - double.parse(doc["cft"])).toStringAsFixed(3));
            _totalAmountTamabil = (double.parse(_totalAmountTamabil.toString()) +
                double.parse(doc["totalSale"])).floor();
          });
        }else if(doc["port"].toString().toLowerCase()=="shutarkandi"){
          setState(() {
            _totalStockShutarkandi =
                double.parse(    (double.parse(_totalStockShutarkandi.toString()) - double.parse(doc["cft"])).toStringAsFixed(3));
            _totalAmountShutarkandi = (double.parse(_totalAmountShutarkandi.toString()) +
                double.parse(doc["totalSale"])).floor();
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
                      builder: (context) => NewStoneSaleScreen()));
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
        title: Text('Stone Border Sale List'),
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
                  "Tamabil Stock : $_totalStockTamabil CFT",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                nameSearchField,
                yearSearchField,
                Text(
                  "Tamabil Total Sale : $_totalAmountTamabil TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shutarkandi Stock : $_totalStockShutarkandi CFT",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),

                Text(
                  "Shutarkandi Total Sale : $_totalAmountShutarkandi TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Expanded(child: (search) ? _searchBuilder() : (yearSearch)? _yearSearchBuilder() :_buildListView()),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("stones");

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
                    element["year"].contains(yearSearchController.text))
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
                    .where((QueryDocumentSnapshot<Object?> element) =>
                element["buyerName"].toString().toLowerCase().contains(searchController.text))
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
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget buildSingleItem( stone) => Container(
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
                      stone["date"],
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
                      stone["invoice"],
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
                      stone["truckCount"],
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
                      stone["truckNumber"],
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
                      stone["port"],
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
                      stone["buyerName"],
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
                      stone["buyerContact"],
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
                      stone["paymentType"],
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
                      stone["paymentInformation"],
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
                      stone["cft"],
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
                      stone["rate"],
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
                      stone["totalSale"],
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
                      stone["remarks"],
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
                        .collection('stones')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["invoice"] == stone["invoice"]){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StoneUpdateScreen(
                                    stoneModel: stone,
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
                        .collection('stones')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if( doc["invoice"] == stone["invoice"]){
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
                        if( doc["id"] ==  "stonesale" + stone["invoice"]){
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
    final _list = <StoneSaleItem>[];
    final _docList = [];
    FirebaseFirestore.instance
        .collection('stones').orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(yearSearchController.text.isNotEmpty && searchController.text.isEmpty){
          if( doc["year"].contains(yearSearchController.text)){
            _list.add(new StoneSaleItem(
              doc["date"],
              doc["truckCount"],
              doc["truckNumber"],
              doc["port"],
              doc["buyerName"],
              doc["buyerContact"],
              doc["cft"],
              doc["rate"],
              doc["totalSale"],
              doc["paymentType"],
              doc["paymentInformation"],
              doc["remarks"],
            ));
            _docList.add(doc);
          }
        }
        else if(searchController.text.isNotEmpty && yearSearchController.text.isEmpty){
          if( doc["buyerName"].toString().toLowerCase().contains(searchController.text)){

            _list.add(new StoneSaleItem(
              doc["date"],
              doc["truckCount"],
              doc["truckNumber"],
              doc["port"],
              doc["buyerName"],
              doc["buyerContact"],
              doc["cft"],
              doc["rate"],
              doc["totalSale"],
              doc["paymentType"],
              doc["paymentInformation"],
              doc["remarks"],
            ));
            _docList.add(doc);
          }
        }
        else{
          _list.add(new StoneSaleItem(
            doc["date"],
            doc["truckCount"],
            doc["truckNumber"],
            doc["port"],
            doc["buyerName"],
            doc["buyerContact"],
            doc["cft"],
            doc["rate"],
            doc["totalSale"],
            doc["paymentType"],
            doc["paymentInformation"],
            doc["remarks"],
          ));
          _docList.add(doc);
        }
      }
      final invoice = InvoiceStoneSale(_list);

      final pdfFile =  PdfStoneSale.generate(invoice);
      _list.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
