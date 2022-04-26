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

class SingleCoalLCScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> coalModel;

  const SingleCoalLCScreen({Key? key, required this.coalModel})
      : super(key: key);

  @override
  _SingleCoalLCScreenState createState() => _SingleCoalLCScreenState();
}

class _SingleCoalLCScreenState extends State<SingleCoalLCScreen> {
  double _totalStock = 0.0;
  int _totalAmount = 0;
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
        .collection('coals')
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
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
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
          disFAB?_process = false: null;
          disFAB?_count = 1:null;
          setState(() {

          });
          disFAB? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("LC Closed!!"))) :  (_count! < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red, content: Text("Please Wait!!")))
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
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {

                            FirebaseFirestore.instance
                                .collection('coals')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                if(doc["lc"] == coal["lc"] && doc["invoice"] == coal["invoice"]){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleCoalUpdateScreen(
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
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('coals')
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
        FirebaseFirestore.instance.collection("coals");

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
                            builder: (context) => SingleCoalEntryScreen(
                                  coalModel: widget.coalModel,
                                )));
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
        child: Form(
          key: _formKey,
          child: Column(
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
              rateField,
              SizedBox(
                height: 20,
              ),
              addButton,
              SizedBox(
                height: 20,
              ),
              Expanded(child: _buildListView()),
            ],
          ),
        ),
      ),
      floatingActionButton: _getFAB(),
    );
  }

  void AddData() async{
    if (_formKey.currentState!.validate()) {

      final _totalPrice = (double.parse(_totalStock.toString()) *
              double.parse(rateEditingController.text)).floor()
          .toString();
      //final _totalBalance = (double.parse(_purchaseBalance) + double.parse(lcOpenPriceEditingController.text) + double.parse(dutyCostEditingController.text) + double.parse(speedMoneyEditingController.text)).toString();
      final ref = FirebaseFirestore.instance.collection("coals").doc();
      final Coal coalModel = Coal();
      coalModel.lc = widget.coalModel.get("lc");
      coalModel.date = "LC Closed";
      coalModel.invoice ="0";
     coalModel.supplierName =  widget.coalModel.get("supplierName");
   coalModel.port =  widget.coalModel.get("port");
    coalModel.ton = "0";
    coalModel.rate = rateEditingController.text;
    coalModel.totalPrice = _totalPrice;
   coalModel.paymentType = "LC Closed";
   coalModel.paymentInformation =  "LC Closed";
   coalModel.credit =  _totalPrice;
   coalModel.debit =  "0";
   coalModel.remarks =  "LC Closed";
   coalModel.year =  widget.coalModel.get("date");
    coalModel.truckCount = "LC Closed";
   coalModel.truckNumber =  "LC Closed";
  coalModel.contact =   widget.coalModel.get("contact");
  coalModel.docID = ref.id;
 await ref.set(coalModel.toMap());


      int _invoiceC = 1;

      FirebaseFirestore.instance
          .collection('companies')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc["name"] == widget.coalModel.get("supplierName")) {
            if (_invoiceC <= int.parse(doc["invoice"])) {
              _invoiceC = int.parse(doc["invoice"]) + 1;
            }
          }
        }



        final ref2 = FirebaseFirestore.instance.collection("companies").doc();
        Company companyModel = Company();
        companyModel.id = "coalstock" + widget.coalModel.get("lc");
        companyModel.name = widget.coalModel.get("supplierName");
        companyModel.contact = widget.coalModel.get("contact");
        companyModel.address = "0";
        companyModel.credit ="0" ;
        companyModel.debit = _totalPrice;
        companyModel.remarks = "Coal Purchase :" + widget.coalModel.get("lc") + " : " + _totalStock.toString() + " Ton";
        companyModel.invoice = _invoiceC.toString();
        companyModel.paymentTypes = "0";
        companyModel.paymentInfo = "0";
        companyModel.date = widget.coalModel.get("date");
        companyModel.year = "0";
        companyModel.docID = ref2.id;
        ref2.set(companyModel.toMap());


        setState(() {
          _totalAmount = double.parse(_totalPrice).floor();
          disFAB = true;
          rateEditingController.clear();
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

  void generatePdf() async {
    final _list = <CoalItem>[];
   var rate ;

    FirebaseFirestore.instance
        .collection('coals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["lc"].toString().toLowerCase() == widget.coalModel.get("lc").toString().toLowerCase()){

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
              doc["remarks"]));


          if(doc["rate"] != "0"){
            rate = doc["rate"];
          }
        }
      }



      final invoice = InvoiceCoal(_totalStock.toString(), _totalAmount.toString(),
          widget.coalModel.get("lc"), rate, _list);

      final pdfFile = PdfCoal.generate(invoice, false);
    });


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
