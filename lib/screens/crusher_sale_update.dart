import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';

import '../model/company.dart';
import '../model/csale.dart';
import 'crusher_sale_s_screen.dart';
import 'crusher_sale_t_screen.dart';

class CrusherSaleUpdateScreen extends StatefulWidget {
  final CSale cSale;
  final dynamic k;
  const CrusherSaleUpdateScreen(
      {Key? key, required this.cSale, required this.k})
      : super(key: key);

  @override
  _CrusherSaleUpdateScreenState createState() =>
      _CrusherSaleUpdateScreenState();
}

class _CrusherSaleUpdateScreenState extends State<CrusherSaleUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  var truckCountEditingController;
  var cftEditingController;
  var rateEditingController;
  var threeToFourEditingController;
  var oneToSixEditingController;
  var halfEditingController;
  var fiveToTenEditingController;
  var remarksEditingController;
  var truckNumberEditingController;
  DateTime? _date;
  bool? _process;
  int? _count;
  int? _invoice;
  final _portTypes = ['Shutarkandi', 'Tamabil'];
  String? _chosenPort;

  List<String> _companyNameList = [];
  String? _chosenCompanyName;
  List<String> _companyContactList = [];
  String? _chosenCompanyContact;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
    _chosenCompanyContact = widget.cSale.buyerContact;
    _chosenCompanyName = widget.cSale.buyerName;
    _chosenPort = widget.cSale.port;
    _invoice = int.parse(widget.cSale.invoice);
    _date = DateFormat("dd-MMM-yyyy").parse(widget.cSale.date);

    truckCountEditingController =
        new TextEditingController(text: widget.cSale.truckCount);
           truckNumberEditingController =
        new TextEditingController(text: widget.cSale.truckNumber);
    cftEditingController = new TextEditingController(text: widget.cSale.cft);

    rateEditingController = new TextEditingController(text: widget.cSale.rate);
    remarksEditingController =
        new TextEditingController(text: widget.cSale.remarks);

    threeToFourEditingController =
        new TextEditingController(text: widget.cSale.threeToFour);
    oneToSixEditingController =
        new TextEditingController(text: widget.cSale.oneToSix);

    halfEditingController = new TextEditingController(text: widget.cSale.half);
    fiveToTenEditingController =
        new TextEditingController(text: widget.cSale.fiveToTen);

    final _tempCompanyList = Hive.box('companies')
        .values
        .where((c) => c.invoice.toLowerCase().contains("1"))
        .toList();
    for (int i = 0; i < _tempCompanyList.length; i++) {
      final _tempCompany = _tempCompanyList[i] as Company;
      _companyNameList.add(_tempCompany.name);
      _companyContactList.add(_tempCompany.contact);
    }
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

    final cftField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: cftEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("CFT cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              cftEditingController.text = value!;
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

    final rateField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

    final threeToFourField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: threeToFourEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              threeToFourEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '3/4',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final oneToSixField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: oneToSixEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              oneToSixEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '16 mm',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final halfField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: halfEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              halfEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '1/2',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final fiveToTenField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: fiveToTenEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              fiveToTenEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '5/10',
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

                final _tempCompanyList = Hive.box('companies')
                    .values
                    .where((c) => c.invoice.toLowerCase().contains("1"))
                    .toList();
                for (int i = 0; i < _tempCompanyList.length; i++) {
                  final _tempCompany = _tempCompanyList[i] as Company;
                  if (_tempCompany.name.contains(newValue!)) {
                    _chosenCompanyContact = _tempCompany.contact;
                  }
                }
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

                final _tempCompanyList = Hive.box('companies')
                    .values
                    .where((c) => c.invoice.toLowerCase().contains("1"))
                    .toList();
                for (int i = 0; i < _tempCompanyList.length; i++) {
                  final _tempCompany = _tempCompanyList[i] as Company;
                  if (_tempCompany.contact.contains(newValue!)) {
                    _chosenCompanyName = _tempCompany.name;
                  }
                }
              });
            }));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Update'),
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
                      children: [cftField, rateField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [threeToFourField, oneToSixField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [halfField, fiveToTenField],
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
                    portDropdown,
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

  void AddData() {
    dynamic _id;
    if (_formKey.currentState!.validate() && _date != null) {
      final cSaleBox = Hive.box('cSales');
      final _price = (double.parse(cftEditingController.text) *
              double.parse(rateEditingController.text))
          .toString();

      if (_chosenPort == "Shutarkandi") {
        final cSaleModel = CSale(
            _invoice.toString(),
            DateFormat('dd-MMM-yyyy').format(_date!),
            truckCountEditingController.text,
            cftEditingController.text,
            rateEditingController.text,
            _price,
            threeToFourEditingController.text,
            oneToSixEditingController.text,
            halfEditingController.text,
            fiveToTenEditingController.text,
            remarksEditingController.text,
            _chosenPort!,
            _chosenCompanyName!,
            _chosenCompanyContact!,
            DateFormat('MMM-yyyy').format(_date!),
            truckNumberEditingController.text);
        cSaleBox.put(widget.k, cSaleModel);
        Hive.box('companies').toMap().forEach((key, value) {
          if (value.id == "crushersaleshutarkandi" + _invoice.toString()) {
            _id = key;
          }
        });
        final companyModel = Company(
            "crushersaleshutarkandi" + _invoice.toString(),
            _chosenCompanyName!,
            _chosenCompanyContact!,
            "0",
            "0",
            _price,
            "Crusher Sale Shutarkandi",
            "2",
            "0",
            "0",
            DateFormat('dd-MMM-yyyy').format(_date!),
            DateFormat('MMM-yyyy').format(_date!));
        Hive.box('companies').put(_id, companyModel);
      } else {
        final cSaleModel = CSale(
            _invoice.toString(),
            DateFormat('dd-MMM-yyyy').format(_date!),
            truckCountEditingController.text,
            cftEditingController.text,
            rateEditingController.text,
            _price,
            threeToFourEditingController.text,
            oneToSixEditingController.text,
            halfEditingController.text,
            fiveToTenEditingController.text,
            remarksEditingController.text,
            _chosenPort!,
            _chosenCompanyName!,
            _chosenCompanyContact!,
            DateFormat('MMM-yyyy').format(_date!),
            truckNumberEditingController.text);
        cSaleBox.put(widget.k, cSaleModel);
        Hive.box('companies').toMap().forEach((key, value) {
          if (value.id == "crushersaletamabil" + _invoice.toString()) {
            _id = key;
          }
        });
        final companyModel = Company(
            "crushersaletamabil" + _invoice.toString(),
            _chosenCompanyName!,
            _chosenCompanyContact!,
            "0",
            "0",
            _price,
            "Crusher Sale Tamabil",
            "2",
            "0",
            "0",
            DateFormat('dd-MMM-yyyy').format(_date!),
            DateFormat('MMM-yyyy').format(_date!));
        Hive.box('companies').put(_id, companyModel);
      }
      setState(() {
        _process = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Entry Added!!")));

      if (_chosenPort == "Shutarkandi") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CrusherSaleSScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CrusherSaleTScreen()));
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
