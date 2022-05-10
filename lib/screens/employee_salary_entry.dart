import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsystemonline/screens/single_employee_screen.dart';
import 'package:intl/intl.dart';

import '../model/employee.dart';
import 'dashboard.dart';

class EmployeeSalaryEntryScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> employeeModel;

  const EmployeeSalaryEntryScreen({Key? key, required this.employeeModel})
      : super(key: key);

  @override
  _EmployeeSalaryEntryScreenState createState() =>
      _EmployeeSalaryEntryScreenState();
}

class _EmployeeSalaryEntryScreenState extends State<EmployeeSalaryEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final salaryAdvancedEditingController = new TextEditingController();
  final salaryGivenEditingController = new TextEditingController();
  final remarksEditingController = new TextEditingController();
  DateTime? _date;
  bool? _process;
  int? _count;
  int _invoice = 1;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;

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
              minWidth: MediaQuery
                  .of(context)
                  .size
                  .width / 6,
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

    final salaryAdvancedField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            cursorColor: Colors.blue,
            autofocus: false,
            controller: salaryAdvancedEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              salaryAdvancedEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Salary Advanced',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final salaryGivenField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: salaryGivenEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              salaryGivenEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Salary Given',
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
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
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
          'Add New Entry',
          textAlign: TextAlign.center,
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Employee Name : ${widget.employeeModel["name"]}"),
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
                          "Employee Name : ${widget.employeeModel["name"]}",
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
                        salaryAdvancedField,
                        salaryGivenField
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Salary : ${widget.employeeModel["salary"]}",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
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
      final ref = FirebaseFirestore.instance.collection("employees").doc();



      FirebaseFirestore.instance
          .collection('employees')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if(doc["name"] == widget.employeeModel.get("name")  ){

            if (_invoice <= int.parse(doc["invoice"])) {
              _invoice = int.parse(doc["invoice"]) + 1;
            }
          }
        }

      Employee employeeModel = Employee();
      employeeModel.date =    DateFormat('yyyy-MM-dd').format(_date!);
      employeeModel.name =     widget.employeeModel["name"];
      employeeModel.post =   widget.employeeModel["post"];
      employeeModel.salary =    widget.employeeModel["salary"];
      employeeModel.salaryAdvanced =    salaryAdvancedEditingController.text;
      employeeModel.balance =        salaryGivenEditingController.text;
      employeeModel.due =       "0";
      employeeModel.remarks =    remarksEditingController.text;
      employeeModel.invoice =      _invoice.toString();
      employeeModel.contact =     widget.employeeModel["contact"];
      employeeModel.address =    widget.employeeModel["address"];
      employeeModel.year =    DateFormat('MMM-yyyy').format(_date!);
      employeeModel.docID = ref.id;
       ref.set(employeeModel.toMap());

      FirebaseFirestore.instance
          .collection('employees')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc.id == ref.id) {
            setState(() {
              _process = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Entry Added!!")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SingleEmployeeScreen(employeeModel: doc)));
          }
        }
      });
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
