import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../api/pdf_coal.dart';
import '../model/coal.dart';
import '../model/coal_archive.dart';
import '../model/invoiceCoal.dart';
import '../model/stone.dart';
import 'coal_sale_entry_screen.dart';
import 'coal_sale_update_screen.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';

class CoalSaleScreen extends StatefulWidget {
  const CoalSaleScreen({Key? key}) : super(key: key);

  @override
  _CoalSaleScreenState createState() => _CoalSaleScreenState();
}

class _CoalSaleScreenState extends State<CoalSaleScreen> {
  double _totalStock = 0.0;
  int _totalAmount = 0;

  DateTime? _date;
  bool? _process;
  int? _count;

  final TextEditingController searchController = TextEditingController();
  bool search = false;
  final TextEditingController yearSearchController = TextEditingController();
  bool yearSearch = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;

    FirebaseFirestore.instance
        .collection('coals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lc"].toString().toLowerCase() != "sale") {
          setState(() {
            _totalStock = double.parse((_totalStock + double.parse(doc["ton"])).toStringAsFixed(3));
          });
        }else{
          setState(() {
            _totalStock = double.parse((_totalStock - double.parse(doc["ton"])).toStringAsFixed(3));
            _totalAmount = (_totalAmount + double.parse(doc["debit"])).floor();
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


    final pickDate = Container(
      child: Row(
        children: [
          SizedBox(
            width: 10,
            height: 20,
          ),
          Material(
            elevation: 5,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                10,
                10,
                10,
                10,
              ),
              minWidth: MediaQuery.of(context).size.width / 6,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _date ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _date = value;
                  });
                });
              },
              child: Text(
                (_date == null)
                    ? 'Pick Year'
                    : DateFormat('yyyy').format(_date!),
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );


    final addButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.red.shade800 : Colors.red,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          15,
          10,
          15,
          10,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _process = true;
            _count = (_count! - 1);
          });
          (_count! < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text("Please Wait!!")))
              :   showDialog(
              context: context,
              builder: (BuildContext context)=>AlertDialog(
                title: Text("Confirm"),
                content: Text("Do you want to archive it?"),
                actions: [
                  IconButton(
                      icon: new Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  IconButton(
                      icon: new Icon(Icons.archive),
                      onPressed: () {
                        AddData();
                        Navigator.pop(context);
                      })
                ],
              )
          );;
        },
        child: (_process!)
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Processing',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Center(
                child: SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))),
          ],
        )
            : Text(
          'Archive',
          textAlign: TextAlign.center,
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
        title: Text('Coal Sale List'),
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
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                pickDate,
                SizedBox(
                  width: 20,
                ),
                addButton,
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


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("coals");

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
                    .where((QueryDocumentSnapshot<Object?> element) => element["lc"].toString().toLowerCase() == "sale" &&
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



  void AddData() async {
    try {
      int _invoiceA  =  1;
      FirebaseFirestore.instance
          .collection('coalarchive')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc2 in querySnapshot.docs) {
          if (doc2["archiveName"].toString() ==
              DateFormat('yyyy').format(_date!) + " : " + "Sale") {
            if (_invoiceA <= int.parse(doc2["archive"])) {
              _invoiceA = int.parse(doc2["archive"]) + 1;
            }
          }
        }
      });
   await   FirebaseFirestore.instance
          .collection('coals')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc["year"].toString().contains(DateFormat('yyyy').format(_date!))&&doc["lc"].toString().toLowerCase() == "sale") {
            /*FirebaseFirestore.instance
                .collection('coalarchive')
                .get()
                .then((QuerySnapshot querySnapshot) {
              for (var doc in querySnapshot.docs) {
                if (!doc["archiveName"].toString().toLowerCase().contains("sale")) {
                  if (_invoiceA <= int.parse(doc["archive"])) {
                    _invoiceA = int.parse(doc["archive"]) + 1;
                  }
                }
              }*/
            var ref =
            FirebaseFirestore.instance.collection("coalarchive").doc();
            CoalArchive coalModel = CoalArchive();
            coalModel.archive = _invoiceA.toString();
            coalModel.archiveName =
                doc["year"].toString().split("-").last + " : " + "Sale";
            coalModel.lc = doc["lc"];
            coalModel.date = doc["date"];
            coalModel.invoice = doc["invoice"];
            coalModel.supplierName = doc["supplierName"];
            coalModel.port = doc["port"];
            coalModel.ton = doc["ton"];
            coalModel.rate = doc["rate"];
            coalModel.totalPrice = doc["totalPrice"];
            coalModel.paymentType = doc["paymentType"];
            coalModel.paymentInformation = doc["paymentInformation"];
            coalModel.credit = doc["credit"];
            coalModel.debit = doc["debit"];
            coalModel.remarks = doc["remarks"];
            coalModel.year = doc["year"];
            coalModel.truckCount = doc["truckCount"];
            coalModel.truckNumber = doc["truckNumber"];
            coalModel.contact = doc["contact"];
            coalModel.docID = ref.id;
            ref.set(coalModel.toMap());
            _invoiceA = _invoiceA + 1;
            doc.reference.delete();
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("Data archived!!")));
        setState(() {
          _process = false;
          _count = 1;
          _date = null;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Something wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
        _date = null;
      });
    }
  }


  void generatePdf() async {
    final _list = <CoalItem>[];

    final _docList = [];
    FirebaseFirestore.instance
        .collection('coals').orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["lc"].toString().toLowerCase() == "sale"){



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


          _docList.add(doc);

        }
      }

      final invoice = InvoiceCoal(_totalStock.toString(), _totalAmount.toString(), "sale","0", _list);
      final pdfFile =  PdfCoal.generate(invoice, true);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
