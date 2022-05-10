import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../api/pdf_invoice_api_stone_purchase.dart';
import '../model/company.dart';
import '../model/cstock.dart';
import '../model/invoiceStonePurchase.dart';
import '../model/lc.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';
import 'individual_lc_update_screen.dart';

class IndividualLCHistoryScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> lcModel;

  const IndividualLCHistoryScreen({Key? key, required this.lcModel})
      : super(key: key);

  @override
  _IndividualLCHistoryScreenState createState() =>
      _IndividualLCHistoryScreenState();
}

class _IndividualLCHistoryScreenState extends State<IndividualLCHistoryScreen> {
  double _totalStock = 0.0;
  int _totalAmount = 0;
  final lcOpenPriceEditingController = new TextEditingController();
  final dutyCostEditingController = new TextEditingController();
  final speedMoneyEditingController = new TextEditingController();
  final rateEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? _process;
  int? _count;
  bool? _process2;
  int? _count2;
  bool disFAB = false;
  String rate = "0";
  String lcOpenPrice = "0";
  String dutyCost = "0";
  String speedMoney = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;

    _process2 = false;
    _count2 = 1;
    FirebaseFirestore.instance
        .collection('lcs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lcNumber"].toString().toLowerCase() ==
            widget.lcModel.get("lcNumber").toString().toLowerCase()) {
          setState(() {
            _totalStock = double.parse((double.parse(_totalStock.toString()) +
                    double.parse(doc["cft"]))
                .toStringAsFixed(3));
          });

          final _docList = [];
          _docList.add(doc);

          if (double.parse(_docList.last["totalBalance"]) > 0) {
            _totalAmount = double.parse(_docList.last["totalBalance"]).floor();
            disFAB = true;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rateField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            autofocus: false,
            controller: rateEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Rate cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              rateEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Rate',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final lcOpenPriceField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: lcOpenPriceEditingController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("LC Open Price cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              lcOpenPriceEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'LC Open Price',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final dutyCostField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: dutyCostEditingController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Duty Cost cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              dutyCostEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Duty Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final speedMoneyField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: speedMoneyEditingController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Speed Money cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              speedMoneyEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Speed Money',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final addButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.blue.shade800 : Colors.blue,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          100,
          30,
          100,
          30,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _process = true;
            _count = (_count! - 1);
          });
          disFAB ? _process = false : null;
          disFAB ? _count = 1 : null;
          setState(() {});

          disFAB
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green, content: Text("LC Closed!!")))
              : (_count! < 0)
                  ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please Wait!!")))
                  : AddData();
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
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))),
                ],
              )
            : Text(
                'Close LC',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );

    final transferButton = Material(
      elevation: (_process2!) ? 0 : 5,
      color: (_process2!) ? Colors.blue.shade800 : Colors.blue,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          100,
          30,
          100,
          30,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _process2 = true;
            _count2 = (_count2! - 1);
          });
          (widget.lcModel.get("port").toString().toLowerCase() == "shutarkandi")
              ? (_count2! < 0)
                  ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please Wait!!")))
                  : transferData()
              : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content:
                      Text("Port is not shutarkandi. Transaction denied!!")));
        },
        child: (_process2!)
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
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))),
                ],
              )
            : Text(
                'Transfer Data To Crusher Stock ( Shutarkandi ) ',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
    Widget buildSingleItem(lc) => Container(
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
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('lcs')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                if (doc["lcNumber"] == lc["lcNumber"] &&
                                    doc["invoice"] == lc["invoice"]) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IndividualLCUpdateScreen(
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
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('lcs')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                if (doc["lcNumber"] == lc["lcNumber"] &&
                                    doc["invoice"] == lc["invoice"]) {
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
        FirebaseFirestore.instance.collection("lcs");

    Widget _buildListView() {
      return StreamBuilder<QuerySnapshot>(
          stream: _collectionReference
              .orderBy("date", descending: true)
              .snapshots()
              .asBroadcastStream(),
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
                          widget.lcModel.get("lcNumber"))
                      .map((QueryDocumentSnapshot<Object?> data) {
                    return buildSingleItem(data);
                  })
                ],
              );
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
                disFAB
                    ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("LC Closed!!")))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndividualLCEntryScreen(
                                lcModel: widget.lcModel)));
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

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("LC Number ${widget.lcModel["lcNumber"]}"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.white),
                ))
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rateField,
                    lcOpenPriceField,
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [dutyCostField, speedMoneyField],
                ),
                SizedBox(
                  height: 20,
                ),
                addButton,
                SizedBox(
                  height: 20,
                ),
                transferButton,
                SizedBox(
                  height: 20,
                ),
                Expanded(child: _buildListView()),
              ],
            ),
          ),
        ),
        floatingActionButton: _getFAB());
  }

  void AddData() async {
    if (_formKey.currentState!.validate()) {
      final ref = FirebaseFirestore.instance.collection("lcs").doc();
      final _stock = _totalStock.toStringAsFixed(3);
      final _purchaseBalance = (double.parse(_totalStock.toString()) *
              double.parse(rateEditingController.text))
          .floor()
          .toString();
      final _totalBalance = (double.parse(_purchaseBalance) +
              double.parse(lcOpenPriceEditingController.text) +
              double.parse(dutyCostEditingController.text) +
              double.parse(speedMoneyEditingController.text))
          .floor()
          .toString();
      LC lcModel = LC();
      lcModel.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      lcModel.truckCount = "LC Closed";
      lcModel.truckNumber = "LC Closed";
      lcModel.invoice = "LC Closed";
      lcModel.port = "LC Closed";
      lcModel.cft = "0";
      lcModel.rate = rateEditingController.text;
      lcModel.stockBalance = _stock;
      lcModel.sellerName = "LC Closed";
      lcModel.sellerContact = "LC Closed";
      lcModel.paymentType = "LC Closed";
      lcModel.paymentInformation = "LC Closed";
      lcModel.purchaseBalance = _purchaseBalance;
      lcModel.lcOpenPrice = lcOpenPriceEditingController.text;
      lcModel.dutyCost = dutyCostEditingController.text;
      lcModel.speedMoney = speedMoneyEditingController.text;
      lcModel.remarks = "LC Closed";
      lcModel.lcNumber = widget.lcModel["lcNumber"];
      lcModel.totalBalance = _totalBalance;
      lcModel.year = widget.lcModel["year"];
      lcModel.docID = ref.id;
      await ref.set(lcModel.toMap());

      int _invoice = 1;

      FirebaseFirestore.instance
          .collection('companies')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc["name"] == widget.lcModel.get("sellerName")) {
            if (_invoice <= int.parse(doc["invoice"])) {
              _invoice = int.parse(doc["invoice"]) + 1;
            }
          }
        }

        final ref2 = FirebaseFirestore.instance.collection("companies").doc();
        Company companyModel = Company();
        companyModel.id = "stonestock" + widget.lcModel["lcNumber"];
        companyModel.name = widget.lcModel.get("sellerName");
        companyModel.contact = widget.lcModel.get("sellerContact");
        companyModel.address = "0";
        companyModel.credit = "0";
        companyModel.debit = _purchaseBalance;
        companyModel.remarks = "stonestock" +
            widget.lcModel.get("lcNumber") ;
        companyModel.invoice = _invoice.toString();
        companyModel.paymentTypes = "0";
        companyModel.paymentInfo = "0";
        companyModel.date = widget.lcModel.get("date");
        companyModel.year = "0";
        companyModel.docID = ref2.id;
        companyModel.rate = rateEditingController.text;
        companyModel.quantity =  _stock;
        ref2.set(companyModel.toMap());
        setState(() {
          _totalAmount = double.parse(_totalBalance).floor();
          disFAB = true;
          rate = rateEditingController.text;
          lcOpenPrice = lcOpenPriceEditingController.text;
          dutyCost = dutyCostEditingController.text;
          speedMoney = speedMoneyEditingController.text;
          rateEditingController.clear();
          lcOpenPriceEditingController.clear();
          dutyCostEditingController.clear();
          speedMoneyEditingController.clear();
          _process = false;
          _count = 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("LC Closed!!")));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }

  void transferData() {
    //  var _rateS = 0.0;
    // FirebaseFirestore.instance
    //     .collection('lcs')
    //     .get()
    //   .then((QuerySnapshot querySnapshot) {
    //   for (var doc in querySnapshot.docs) {
    //if (doc["lcNumber"] == widget.lcModel.get("lcNumber") &&
    //      doc["port"].toString().toLowerCase() == "shutarkandi" && double.parse(doc["rate"]) > 0) {
    //   _rateS = double.parse(doc["rate"]);
    //    }
    //  }
    //  });
    FirebaseFirestore.instance
        .collection('lcs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lcNumber"] == widget.lcModel.get("lcNumber") &&
            doc["port"].toString().toLowerCase() == "shutarkandi" &&
            doc["invoice"].toString().toLowerCase() != "LC Closed" &&
            double.parse(doc["cft"]) > 0) {
          final ref = FirebaseFirestore.instance.collection("cStocks").doc();
          final _cftS = double.parse(doc["cft"]) * 22;
          final _threeToFourS = (_cftS * 54) / 100;
          final _oneToSixS = (_cftS * 29) / 100;
          final _halfS = (_cftS * 17) / 100;
          final _fiveToTenS = (_cftS * 7) / 100;
          final _totalS = _threeToFourS + _oneToSixS + _halfS + _fiveToTenS;
          final _extraS = _totalS - _cftS;
          //     final _priceS = _rateS * _cftS;

          final _docList = [];
          int _invoice = 1;

          FirebaseFirestore.instance
              .collection('cStocks')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              _docList.add(doc);
            }
            if (_docList.isNotEmpty) {
              setState(() {
                _invoice = int.parse(_docList.last["invoice"]) + 1;
              });
            }
            CStock cStockModel = CStock();
            cStockModel.invoice = _invoice.toString();
            cStockModel.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
            cStockModel.truckCount = doc["truckCount"];
            cStockModel.port = doc["port"];
            cStockModel.ton = _cftS.toString();
            cStockModel.cft = _cftS.toString();
            cStockModel.threeToFour = _threeToFourS.toStringAsFixed(3);
            cStockModel.oneToSix = _oneToSixS.toStringAsFixed(3);
            cStockModel.half = _halfS.toStringAsFixed(3);
            cStockModel.fiveToTen = _fiveToTenS.toStringAsFixed(3);
            cStockModel.totalBalance = _totalS.toStringAsFixed(3);
            cStockModel.extra = _extraS.toStringAsFixed(3);
            cStockModel.remarks = doc["remarks"];
            cStockModel.supplierName = doc["sellerName"];
            cStockModel.supplierContact = doc["sellerContact"];
            cStockModel.year = doc["year"];
            cStockModel.rate = "0"; // _rateS.toString();
            cStockModel.price = "0"; //_priceS.toString();
            cStockModel.truckNumber = doc["truckNumber"];
            cStockModel.docID = ref.id;
            ref.set(cStockModel.toMap());

            setState(() {
              _process2 = false;
              _count2 = 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Data Transferred!!")));
          });
        }
      }
    });
  }

  void generatePdf() async {
    final _list = <StonePurchaseItem>[];
    var rate2;
    var lcOpenPrice2;
    var dutyCost2;
    var speedMoney2;

    FirebaseFirestore.instance
        .collection('lcs').orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lcNumber"].toString().toLowerCase() ==
            widget.lcModel.get("lcNumber").toString().toLowerCase()) {
          _list.add(new StonePurchaseItem(
            doc["date"],
            doc["truckCount"],
            doc["truckNumber"],
            doc["port"],
            doc["cft"],
            doc["remarks"],
          ));

          if (doc["rate"] != "0") {
            rate2 = doc["rate"];
            lcOpenPrice2 = doc["lcOpenPrice"];
            dutyCost2 = doc["dutyCost"];
            speedMoney2 = doc["speedMoney"];
          }
        }
      }
      final invoice = InvoiceStonePurchase(
          widget.lcModel["lcNumber"],
          widget.lcModel["sellerName"],
          widget.lcModel["sellerContact"],
          rate2 ?? "0",
          lcOpenPrice2?? "0",
          dutyCost2 ?? "0",
          speedMoney2 ?? "0",
          _list);

      final pdfFile = PdfInvoiceApiStonePurchase.generate(invoice);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
