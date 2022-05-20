import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import '../api/pdf_crusher_stock.dart';
import '../model/csale.dart';
import '../model/cstock.dart';
import '../model/invoiceCrusherStock.dart';
import '../model/stone.dart';
import 'crusher_stock_entry.dart';
import 'crusher_stock_update.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';

class CrusherStockTScreen extends StatefulWidget {
  const CrusherStockTScreen({Key? key}) : super(key: key);

  @override
  _CrusherStockTScreenState createState() => _CrusherStockTScreenState();
}

class _CrusherStockTScreenState extends State<CrusherStockTScreen> {

  double _totalStock = 0.0;
  int _totalSale = 0;

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
        if (doc["port"].toLowerCase() == ("tamabil")) {
          setState(() {
            _totalStock =double.parse( (double.parse(_totalStock.toString()) + double.parse(doc["totalBalance"])).toStringAsFixed(3));
            _totalSale = (_totalSale + double.parse(doc["price"])).floor();
          });
        }
      }
    });
    FirebaseFirestore.instance
        .collection('cSales')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["port"].toLowerCase() == ("tamabil")) {
          setState(() {
            _totalStock =double.parse( (double.parse(_totalStock.toString()) - double.parse(doc["cft"])).toStringAsFixed(3));
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
            child: Icon(Icons.add, color: Colors.white,),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => CrusherStockEntryScreen()));
            },
            label: 'Add Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.picture_as_pdf_outlined,color: Colors.white,),
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
        title: Text(
            'Crusher Stock ( Tamabil )'
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Crusher Stock : $_totalStock CFT",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Total Sale : $_totalSale TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
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
            child: Divider(

            ),
          ),
          Expanded(child: (search) ? _searchBuilder() : (yearSearch)? _yearSearchBuilder() : _buildListView()),
        ],
      ),

      floatingActionButton: _getFAB(),
    );
  }


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("cStocks");

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
                    .where((QueryDocumentSnapshot<Object?> element) =>element["port"].toLowerCase()==("tamabil")&&
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
                    .where((QueryDocumentSnapshot<Object?> element) => element["port"].toLowerCase()==("tamabil") &&
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
                element["port"].toLowerCase() == ("tamabil"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }


  Widget buildSingleItem( cStock) => Container(
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
                  cStock["date"],
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
                  cStock["invoice"],
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
                  cStock["truckCount"],
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
                      cStock["truckNumber"],
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
                  cStock["supplierName"],
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
                  cStock["supplierContact"],
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
                  cStock["cft"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Rate",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock["rate"],
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
                  "Total Price",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock["price"],
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
                  cStock["port"],
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
                  cStock["threeToFour"],
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
                  cStock["oneToSix"],
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
                  cStock["half"],
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
                  cStock["fiveToTen"],
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
                  "Total Balance",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock["totalBalance"],
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
                  "Extra",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock["extra"],
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
                  cStock["remarks"],
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
                        .collection('cStocks')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if (doc["invoice"] == cStock["invoice"] &&
                            doc["port"].toLowerCase() == ("tamabil")) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CrusherStockUpdateScreen(
                                        cStock: cStock,
                                      )));
                        }
                      }
                    });

                    FirebaseFirestore.instance
                        .collection('companies')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if( doc["id"] ==  "crusherstocktamabil" + cStock["invoice"]){
                          setState(() {
                            doc.reference.delete();
                          });
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
                        .collection('cStocks')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if (doc["invoice"] == cStock["invoice"] &&
                            doc["port"].toLowerCase() == ("tamabil")) {
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
    final _list = <CrusherStockItem>[];

    FirebaseFirestore.instance
        .collection('cStocks').orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["port"].toLowerCase() == ("tamabil")) {
          if(yearSearchController.text.isNotEmpty && searchController.text.isEmpty){
            if( doc["year"].contains(yearSearchController.text)){

              _list.add(new CrusherStockItem(
                doc["date"],
                doc["truckCount"],
                doc["port"],
                doc["supplierName"],
                doc["supplierContact"],
                doc["cft"],
                doc["rate"],
                doc["price"],
                doc["threeToFour"],
                doc["oneToSix"],
                doc["half"],
                doc["fiveToTen"],
                doc["totalBalance"],
                doc["extra"],
                doc["remarks"],
              ));
            }
          }
          else if(searchController.text.isNotEmpty && yearSearchController.text.isEmpty){
            if( doc["supplierName"].toString().toLowerCase().contains(searchController.text)){

              _list.add(new CrusherStockItem(
                doc["date"],
                doc["truckCount"],
                doc["port"],
                doc["supplierName"],
                doc["supplierContact"],
                doc["cft"],
                doc["rate"],
                doc["price"],
                doc["threeToFour"],
                doc["oneToSix"],
                doc["half"],
                doc["fiveToTen"],
                doc["totalBalance"],
                doc["extra"],
                doc["remarks"],
              ));
            }
          }
          else{

            _list.add(new CrusherStockItem(
              doc["date"],
              doc["truckCount"],
              doc["port"],
              doc["supplierName"],
              doc["supplierContact"],
              doc["cft"],
              doc["rate"],
              doc["price"],
              doc["threeToFour"],
              doc["oneToSix"],
              doc["half"],
              doc["fiveToTen"],
              doc["totalBalance"],
              doc["extra"],
              doc["remarks"],
            ));
          }



        }
      }


      final invoice = InvoiceCrusherStock(_list);

      final pdfFile =  PdfCrusherStock.generate(invoice);


    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Pdf Generated!!")));

  }
}
