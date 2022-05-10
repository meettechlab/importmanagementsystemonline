import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsystemonline/screens/single_company_screen.dart';
import 'package:intl/intl.dart';

import '../model/company.dart';
import '../model/employee.dart';
import 'dashboard.dart';

class CompanyUpdateScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> companyModel;

  const CompanyUpdateScreen({Key? key, required this.companyModel})
      : super(key: key);

  @override
  _CompanyUpdateScreenState createState() => _CompanyUpdateScreenState();
}

class _CompanyUpdateScreenState extends State<CompanyUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  var debitCreditEditingController;
  var remarksEditingController;
  var paymentInformationEditingController;
  DateTime? _date;
  final _paymentTypes = ['Cash', 'Bank'];
  String? _chosenPayment;
  bool? _process;
  int? _count;
  int? _invoice;
  bool _selection = false;
  String _selectionString = "Credit";
  String _debit = "0";
  String _credit = "0";

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
    _invoice = int.parse(widget.companyModel["invoice"]);
    _date = DateFormat("yyyy-MM-dd").parse(widget.companyModel["date"]);
    _chosenPayment = widget.companyModel["paymentTypes"];

    if (int.parse(widget.companyModel["debit"]) > 0) {
      _selection = true;
      debitCreditEditingController =
          new TextEditingController(text: widget.companyModel["debit"]);
    } else {
      debitCreditEditingController =
          new TextEditingController(text: widget.companyModel["credit"]);
    }
    paymentInformationEditingController =
        new TextEditingController(text: widget.companyModel["paymentInfo"]);
    remarksEditingController =
        new TextEditingController(text: widget.companyModel["remarks"]);
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
                    : DateFormat('yyyy-MM-dd').format(_date!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final paymentInformationField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: paymentInformationEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (_chosenPayment == "") {
                return ("Payment Type required!!");
              } else if (_chosenPayment == 'Bank') {
                if (value!.isEmpty) {
                  return ("Payment Information cannot be empty!!");
                }
              }
              return null;
            },
            onSaved: (value) {
              paymentInformationEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Payment Information',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final debitCreditField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: debitCreditEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              debitCreditEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Debit/Credit',
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

    final paymentDropdown = Container(
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
            items: _paymentTypes.map(buildMenuItem).toList(),
            hint: Text(
              'Select Payment',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenPayment,
            onChanged: (newValue) {
              setState(() {
                _chosenPayment = newValue;
              });
            }));

    final checkField = Checkbox(
      activeColor: Colors.transparent,
      side: BorderSide(color: Colors.blue),
      checkColor: Colors.blue,
      onChanged: (bool? value) {
        setState(() {
          _selection = value!;
          if (_selection) {
            _selectionString = "Debit";
          } else {
            _selectionString = "Credit";
          }
        });
      },
      value: _selection,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Client/Supplier Name : ${widget.companyModel["name"]}"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Client Name : ${widget.companyModel["name"]}",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                        pickDate,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            checkField,
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              _selectionString,
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                        debitCreditField
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [paymentDropdown, paymentInformationField],
                    ),
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
    if (_formKey.currentState!.validate() && _date != null) {
      final ref = FirebaseFirestore.instance
          .collection("companies")
          .doc(widget.companyModel.get("docID"));
      if (_selection) {
        _debit = debitCreditEditingController.text;
      } else {
        _credit = debitCreditEditingController.text;
      }

      Company companyModel = Company();
      companyModel.id = widget.companyModel["id"];
      companyModel.name = widget.companyModel["name"];
      companyModel.contact = widget.companyModel["contact"];
      companyModel.address = widget.companyModel["address"];
      companyModel.credit = _credit;
      companyModel.debit = _debit;
      companyModel.remarks = remarksEditingController.text;
      companyModel.invoice = _invoice.toString();
      companyModel.paymentTypes = _chosenPayment!;
      companyModel.paymentInfo = paymentInformationEditingController.text;
      companyModel.date = DateFormat('yyyy-MM-dd').format(_date!);
      companyModel.year = DateFormat('MMM-yyyy').format(_date!);
      companyModel.docID = widget.companyModel["docID"];
      companyModel.rate = "0";
      companyModel.quantity =  "0";
      await ref.set(companyModel.toMap());

      FirebaseFirestore.instance
          .collection('companies')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc.id == ref.id) {
            setState(() {
              _process = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Entry Updated!!")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SingleCompanyScreen(companyModel: doc)));
          }
        }
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
}
