import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import '../api/pdf_crusher_sale.dart';
import '../model/csale.dart';
import '../model/cstock.dart';
import '../model/invoiceCrusherSale.dart';
import '../model/invoiceCrusherStock.dart';
import '../model/stone.dart';
import 'crusher_sale_entry_screen.dart';
import 'crusher_sale_update.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';

class CrusherSaleSScreen extends StatefulWidget {
  const CrusherSaleSScreen({Key? key}) : super(key: key);

  @override
  _CrusherSaleSScreenState createState() => _CrusherSaleSScreenState();
}

class _CrusherSaleSScreenState extends State<CrusherSaleSScreen> {
  double _totalStock = 0.0;
  int _totalSale = 0;
  double _threeToFour = 0.0;
  double _oneToSix = 0.0;
  double _half = 0.0;
  double _fiveToTen = 0.0;


  final TextEditingController searchController = TextEditingController();
  bool search = false;
  final TextEditingController yearSearchController = TextEditingController();
  bool yearSearch = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('cStocks')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
       if( doc["port"].toLowerCase()==("shutarkandi")){
         setState(() {
           _totalStock = double.parse((double.parse(_totalStock.toString()) +
               double.parse(doc["totalBalance"])).toStringAsFixed(3));
           _threeToFour = double.parse((double.parse(_threeToFour.toString()) +
               double.parse(doc["threeToFour"])).toStringAsFixed(3));
           _oneToSix =
           double.parse((double.parse(_oneToSix.toString()) + double.parse(doc["oneToSix"])).toStringAsFixed(3));
           _half =double.parse( (double.parse(_half.toString()) + double.parse(doc["half"])).toStringAsFixed(3));
           _fiveToTen =double.parse( (double.parse(_fiveToTen.toString()) +
               double.parse(doc["fiveToTen"])).toStringAsFixed(3));
         });
       }
      }
    });
    FirebaseFirestore.instance
        .collection('cSales')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if( doc["port"].toLowerCase()==("shutarkandi")){
          setState(() {
            _totalStock =
            double.parse((double.parse(_totalStock.toString()) - double.parse(doc["cft"])).toStringAsFixed(3));
            _totalSale =
            (double.parse(_totalSale.toString()) + double.parse(doc["price"])).floor();
            _threeToFour =double.parse( (double.parse(_threeToFour.toString()) -
                double.parse(doc["threeToFour"])).toStringAsFixed(3));
            _oneToSix =
          double.parse(  (double.parse(_oneToSix.toString()) - double.parse(doc["oneToSix"])).toStringAsFixed(3));
            _half =double.parse( (double.parse(_half.toString()) - double.parse(doc["half"])).toStringAsFixed(3));
            _fiveToTen =double.parse( (double.parse(_fiveToTen.toString()) -
                double.parse(doc["fiveToTen"])).toStringAsFixed(3));
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
                      builder: (context) => CrusherSaleEntryScreen()));
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
        title: Text('Crusher Sale ( Shutarkandi )'),
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
          individualStock(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nameSearchField,
                yearSearchField
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
      floatingActionButton: _getFAB(),
    );
  }

  Widget individualStock() => Container(
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
                      "3/4",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      _threeToFour.toString(),
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
                      "16 mm",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      _oneToSix.toString(),
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
                      "1/2",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      _half.toString(),
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
                      "5/10",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      _fiveToTen.toString(),
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
                      "Total stock",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      _totalStock.toString(),
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
                      "Total Sale",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      _totalSale.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("cSales");

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
                    .where((QueryDocumentSnapshot<Object?> element) =>element["port"].toLowerCase()==("shutarkandi")&&
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
                    .where((QueryDocumentSnapshot<Object?> element) => element["port"].toLowerCase()==("shutarkandi") &&
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
                    .where((QueryDocumentSnapshot<Object?> element) =>
                element["port"].toLowerCase()==("shutarkandi"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget buildSingleItem( cSale) => Container(
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
                      cSale["date"],
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
                      cSale["invoice"],
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
                      cSale["truckCount"],
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
                      cSale["truckNumber"],
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
                      cSale["buyerName"],
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
                      cSale["buyerContact"],
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
                      cSale["cft"],
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
                      cSale["rate"],
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
                      "Price",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      cSale["price"],
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
                      "3/4",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      cSale["threeToFour"],
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
                      "16 mm",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      cSale["oneToSix"],
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
                      "1/2",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      cSale["half"],
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
                      "5/10",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      cSale["fiveToTen"],
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
                      cSale["remarks"],
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
                        .collection('cSales')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["invoice"] == cSale["invoice"] && doc["port"].toLowerCase() == ("shutarkandi")){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CrusherSaleUpdateScreen(
                                    cSale: cSale,
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
                        .collection('cSales')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["invoice"] == cSale["invoice"] && doc["port"].toLowerCase() == ("shutarkandi")){
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
                        if( doc["id"] ==  "crushersaleshutarkandi" + cSale["invoice"]){
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
    final _list = <CrusherSaleItem>[];
    FirebaseFirestore.instance
        .collection('cSales').orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["port"].toLowerCase()==("shutarkandi")){
          if(yearSearchController.text.isNotEmpty && searchController.text.isEmpty){
            if( doc["year"].contains(yearSearchController.text)){

              _list.add(new CrusherSaleItem(
                doc["date"],
                doc["truckCount"],
                doc["port"],
                doc["buyerName"],
                doc["buyerContact"],
                doc["cft"],
                doc["rate"],
                doc["price"],
                doc["threeToFour"],
                doc["oneToSix"],
                doc["half"],
                doc["fiveToTen"],
                doc["remarks"],
              ));
            }
          }
          else if(searchController.text.isNotEmpty && yearSearchController.text.isEmpty){
            if( doc["buyerName"].toString().toLowerCase().contains(searchController.text)){


              _list.add(new CrusherSaleItem(
                doc["date"],
                doc["truckCount"],
                doc["port"],
                doc["buyerName"],
                doc["buyerContact"],
                doc["cft"],
                doc["rate"],
                doc["price"],
                doc["threeToFour"],
                doc["oneToSix"],
                doc["half"],
                doc["fiveToTen"],
                doc["remarks"],
              ));
            }
          }
          else{

            _list.add(new CrusherSaleItem(
              doc["date"],
              doc["truckCount"],
              doc["port"],
              doc["buyerName"],
              doc["buyerContact"],
              doc["cft"],
              doc["rate"],
              doc["price"],
              doc["threeToFour"],
              doc["oneToSix"],
              doc["half"],
              doc["fiveToTen"],
              doc["remarks"],
            ));
          }

        }
      }
      final invoice = InvoiceCrusherSale(
          _threeToFour.toString(),
          _oneToSix.toString(),
          _half.toString(),
          _fiveToTen.toString(),
          _totalStock.toString(),
          _totalSale.toString(),
          _list);

      final pdfFile =  PdfCrusherSale.generate(invoice);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
