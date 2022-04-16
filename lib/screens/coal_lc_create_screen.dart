import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsystemonline/screens/single_coal_lc_screen.dart';
import 'package:intl/intl.dart';

import '../model/coal.dart';
import '../model/company.dart';

class CoalLCCreateScreen extends StatefulWidget {
  const CoalLCCreateScreen({Key? key}) : super(key: key);

  @override
  _CoalLCCreateScreenState createState() => _CoalLCCreateScreenState();
}

class _CoalLCCreateScreenState extends State<CoalLCCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final lcNumberEditingController = new TextEditingController();
  final portEditingController = new TextEditingController();
  final tonEditingController = new TextEditingController();
  final truckCountEditingController = new TextEditingController();
  final truckNumberEditingController = new TextEditingController();
  DateTime? _date;
  final _paymentTypes = ['Cash', 'Bank'];
  String? _chosenPayment;

  List<String> _companyNameList = [];
  String? _chosenCompanyName;
  List<String> _companyContactList = [];
  String? _chosenCompanyContact;
  bool? _process;
  int? _count;


  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;

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

    final truckCountField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
    final lcNumberField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: lcNumberEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("LC Number cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              lcNumberEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'LC Number',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));


    final portField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: portEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Port cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              portEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Port',
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: tonEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Ton cannot be empty!!");
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
              labelText: 'Ton',
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
      elevation: (_process!)? 0 : 5,
      color: (_process!)? Colors.blue.shade800 :Colors.blue,
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
          (_count! < 0) ?      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Wait Please!!")))
              :
          AddData();
        },
        child:(_process!)? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Processing',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            SizedBox(width: 20,),
            Center(child: SizedBox(height:15, width: 15,child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))),
          ],
        )
            : Text(
          'Add New Entry',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );



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
        title: Text('Create New Coal LC'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        lcNumberField,
                        pickDate,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        nameDropdown,
                        contactDropdown
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        truckCountField,
                        truckNumberField
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        portField,
                        tonField
                      ],
                    ),
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
    if (_formKey.currentState!.validate() && _date != null && _chosenCompanyContact != null && _chosenCompanyName != null ) {
      final ref = FirebaseFirestore.instance.collection("coals").doc();
      final _invoice = "1";
      Coal coalModel = Coal();
      coalModel.lc = lcNumberEditingController.text;
      coalModel.date = DateFormat('dd-MMM-yyyy').format(_date!);
      coalModel.invoice = _invoice;
      coalModel.supplierName = _chosenCompanyName!;
      coalModel.port = portEditingController.text;
      coalModel.ton =  tonEditingController.text;
      coalModel.rate = "0";
      coalModel.totalPrice = "0";
      coalModel.paymentType = "0";
      coalModel.paymentInformation = "0";
      coalModel.credit = "0";
      coalModel.debit = "0";
      coalModel.remarks = "0";
      coalModel.year = DateFormat('MMM-yyyy').format(_date!);
      coalModel.truckCount = truckCountEditingController.text;
      coalModel.truckNumber = truckNumberEditingController.text;
      coalModel.contact  = _chosenCompanyContact!;
      coalModel.docID = ref.id;
      await ref.set(coalModel.toMap());

      FirebaseFirestore.instance
          .collection('coals')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if(doc.id == ref.id){

            setState(() {
              _process = false;
              _count = 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Entry Added!!")));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleCoalLCScreen(coalModel: doc)));
          }
        }
      });


    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
