import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';

import '../model/company.dart';
import '../model/csale.dart';
import '../model/cstock.dart';
import 'crusher_stock_s_screen.dart';
import 'crusher_stock_t_screen.dart';
import 'dashboard.dart';

class CrusherStockUpdateScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> cStock;
  const CrusherStockUpdateScreen(
      {Key? key, required this.cStock})
      : super(key: key);

  @override
  _CrusherStockUpdateScreenState createState() =>
      _CrusherStockUpdateScreenState();
}

class _CrusherStockUpdateScreenState extends State<CrusherStockUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  var truckCountEditingController;
  var tonEditingController;
  var remarksEditingController;
  var rateEditingController;
  var truckNumberEditingController;
  DateTime? _date;
  bool? _process;
  int? _count;
  final _portTypes = ['Shutarkandi', 'Tamabil'];
  String? _chosenPort;
  int? _invoice;

  List<String> _companyNameList = [];
  String? _chosenCompanyName;
  List<String> _companyContactList = [];
  String? _chosenCompanyContact;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
    _chosenCompanyContact = widget.cStock["supplierContact"];
    _chosenCompanyName = widget.cStock["supplierName"];
    _chosenPort = widget.cStock["port"];
    _invoice = int.parse(widget.cStock["invoice"]);
    _date = DateFormat("dd-MMM-yyyy").parse(widget.cStock["date"]);

    truckCountEditingController =
        new TextEditingController(text: widget.cStock["truckCount"]);
    truckNumberEditingController =
        new TextEditingController(text: widget.cStock["truckNumber"]);
    tonEditingController = new TextEditingController(text: widget.cStock["ton"]);

    rateEditingController = new TextEditingController(text: widget.cStock["rate"]);
    remarksEditingController =
        new TextEditingController(text: widget.cStock["remarks"]);
    FirebaseFirestore.instance
        .collection('companies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["invoice"] == "1"){
          setState(() {
            _companyNameList.add(doc["name"]);
            _companyContactList.add(doc["contact"]);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pickDate = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Date   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
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
                    ? 'Pick Date'
                    : DateFormat('dd-MMM-yyyy').format(_date!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
    final truckNumberField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: truckNumberEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Truck Plate Number cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              truckNumberEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Truck Plate Number',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

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

    final truckCountField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            cursorColor: Colors.blue,
            autofocus: false,
            controller: truckCountEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("No Of Truck cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              truckCountEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'No of Trucks',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final tonField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: tonEditingController,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("CFT cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              tonEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'CFT',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final remarksField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            maxLines: 3,
            cursorColor: Colors.blue,
            autofocus: false,
            controller: remarksEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              remarksEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Remarks',
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
          150,
          35,
          150,
          35,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _process = true;
            _count = (_count! - 1);
          });
          (_count! < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red, content: Text("Wait Please!!")))
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
                'Update',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final portDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _portTypes.map(buildMenuItem).toList(),
            hint: Text(
              'Select Port',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenPort,
            onChanged: (newValue) {
              setState(() {
                _chosenPort = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuName(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final nameDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _companyNameList.map(buildMenuName).toList(),
            hint: Text(
              'Select Client/Supplier',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenCompanyName,
            onChanged: (newValue) {
              setState(() {
                _chosenCompanyName = newValue;

                FirebaseFirestore.instance
                    .collection('companies')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if(doc["invoice"] == "1" && doc["name"] == newValue ){
                      _chosenCompanyContact = doc["contact"];
                    }
                  }
                });
              });
            }));

    DropdownMenuItem<String> buildMenuContact(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final contactDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _companyContactList.map(buildMenuContact).toList(),
            hint: Text(
              'Select Client/Supplier',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenCompanyContact,
            onChanged: (newValue) {
              setState(() {
                _chosenCompanyContact = newValue;

                FirebaseFirestore.instance
                    .collection('companies')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if(doc["invoice"] == "1" && doc["contact"] == newValue ){
                      _chosenCompanyName = doc["name"];
                    }
                  }
                });
              });
            }));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Update'),
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
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    pickDate,
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        truckCountField,
                        truckNumberField,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tonField,
                        portDropdown,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [nameDropdown, contactDropdown],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    rateField,
                    SizedBox(
                      height: 20,
                    ),
                    remarksField,
                    SizedBox(
                      height: 20,
                    ),
                    addButton,
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void AddData() async {
    if (_formKey.currentState!.validate() &&
        _chosenPort != null &&
        _date != null &&
        _chosenCompanyName != null &&
        _chosenCompanyContact != null) {
      final ref = FirebaseFirestore.instance.collection("cStocks").doc(widget.cStock["docID"]);
      final _cftS = double.parse(tonEditingController.text);
      final _cftT = double.parse(tonEditingController.text);
      final _threeToFourS = (_cftS * 54) / 100;
      final _threeToFourT = (_cftT * 55) / 100;
      final _oneToSixS = (_cftS * 29) / 100;
      final _oneToSixT = (_cftT * 30) / 100;
      final _halfS = (_cftS * 17) / 100;
      final _halfT = (_cftT * 15) / 100;
      final _fiveToTenS = (_cftS * 7) / 100;
      final _fiveToTenT = (_cftT * 7) / 100;
      final _totalS = _threeToFourS + _oneToSixS + _halfS + _fiveToTenS;
      final _totalT = _threeToFourT + _oneToSixT + _halfT + _fiveToTenT;
      final _extraS = _totalS - _cftS;
      final _extraT = _totalT - _cftT;

      final _priceS = _cftS * double.parse(rateEditingController.text);
      final _priceT = _cftT * double.parse(rateEditingController.text);

      String? _docID;

      if (_chosenPort == "Shutarkandi") {

        CStock cStockModel = CStock();
        cStockModel.invoice =    _invoice.toString();
        cStockModel.date =     DateFormat('dd-MMM-yyyy').format(_date!);
        cStockModel.truckCount =   truckCountEditingController.text;
        cStockModel.port =    _chosenPort!;
        cStockModel.ton =   tonEditingController.text;
        cStockModel.cft =   _cftS.toString();
        cStockModel.threeToFour =   _threeToFourS.toStringAsFixed(3);
        cStockModel.oneToSix =   _oneToSixS.toStringAsFixed(3);
        cStockModel.half =   _halfS.toStringAsFixed(3);
        cStockModel.fiveToTen =  _fiveToTenS.toStringAsFixed(3);
        cStockModel.totalBalance =      _totalS.toStringAsFixed(3);
        cStockModel.extra =   _extraS.toStringAsFixed(3);
        cStockModel.remarks =   remarksEditingController.text;
        cStockModel.supplierName =    _chosenCompanyName!;
        cStockModel.supplierContact =   _chosenCompanyContact!;
        cStockModel.year =  DateFormat('MMM-yyyy').format(_date!);
        cStockModel.rate =    rateEditingController.text;
        cStockModel.price =    _priceS.floor().toString();
        cStockModel.truckNumber =       truckNumberEditingController.text;
        cStockModel.docID = ref.id;
        await ref.set(cStockModel.toMap());

        String? _invoiceC;

        FirebaseFirestore.instance
            .collection('companies')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if (doc["id"] == "crushersaleshutarkandi" + widget.cStock["invoice"]) {
              _docID = doc.id;
              _invoiceC = doc["invoice"];

            }
          }


        final ref2= FirebaseFirestore.instance.collection("companies").doc(_docID);
        Company companyModel = Company();
        companyModel.id=   "crusherstockshutarkandi" + _invoice.toString();
        companyModel.name = _chosenCompanyName!;
        companyModel.contact =_chosenCompanyContact!;
        companyModel.address =  "0";
        companyModel.credit =   "0" ;
        companyModel.debit =   _priceS.floor().toString();
        companyModel.remarks =  "Crusher Stock Shutarkandi  : " +  tonEditingController.text + " CFT";
        companyModel.invoice =  _invoiceC;
        companyModel.paymentTypes =  "0";
        companyModel.paymentInfo =  "0";
        companyModel.date =   DateFormat('dd-MMM-yyyy').format(_date!);
        companyModel.year =    DateFormat('MMM-yyyy').format(_date!);
        companyModel.docID = ref2.id;
           ref2.set(companyModel.toMap());
        setState(() {
          _process = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("Entry Added!!")));


        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CrusherStockSScreen()));
        });
      } else {
        CStock cStockModel = CStock();
        cStockModel.invoice = _invoice.toString();
        cStockModel.date = DateFormat('dd-MMM-yyyy').format(_date!);
        cStockModel.truckCount = truckCountEditingController.text;
        cStockModel.port = _chosenPort!;
        cStockModel.ton = tonEditingController.text;
        cStockModel.cft = _cftT.toString();
        cStockModel.threeToFour = _threeToFourT.toStringAsFixed(3);
        cStockModel.oneToSix = _oneToSixT.toStringAsFixed(3);
        cStockModel.half = _halfT.toStringAsFixed(3);
        cStockModel.fiveToTen = _fiveToTenT.toStringAsFixed(3);
        cStockModel.totalBalance = _totalT.toStringAsFixed(3);
        cStockModel.extra = _extraT.toStringAsFixed(3);
        cStockModel.remarks = remarksEditingController.text;
        cStockModel.supplierName = _chosenCompanyName!;
        cStockModel.supplierContact = _chosenCompanyContact!;
        cStockModel.year = DateFormat('MMM-yyyy').format(_date!);
        cStockModel.rate = rateEditingController.text;
        cStockModel.price = _priceT.floor().toString();
        cStockModel.truckNumber = truckNumberEditingController.text;
        cStockModel.docID = ref.id;
        await ref.set(cStockModel.toMap());
        String? _invoiceC;

        FirebaseFirestore.instance
            .collection('companies')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if (doc["id"] == "crusherstocktamabil" + widget.cStock["invoice"]) {
              _docID = doc.id;
              _invoiceC = doc["invoice"];
            }
          }


          final ref2 = FirebaseFirestore.instance.collection("companies").doc(
              _docID);
          Company companyModel = Company();
          companyModel.id = "crusherstocktamabil" + _invoice.toString();
          companyModel.name = _chosenCompanyName!;
          companyModel.contact = _chosenCompanyContact!;
          companyModel.address = "0";
          companyModel.credit = "0" ;
          companyModel.debit = _priceT.floor().toString();
          companyModel.remarks = "Crusher Stock Tamabil : " +  tonEditingController.text + " CFT";
          companyModel.invoice = _invoiceC;
          companyModel.paymentTypes = "0";
          companyModel.paymentInfo = "0";
          companyModel.date = DateFormat('dd-MMM-yyyy').format(_date!);
          companyModel.year = DateFormat('MMM-yyyy').format(_date!);
          companyModel.docID = ref2.id;
          ref2.set(companyModel.toMap());

          setState(() {
            _process = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green, content: Text("Entry Added!!")));

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CrusherStockTScreen()));
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
