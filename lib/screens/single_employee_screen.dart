import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/pdf_employee.dart';
import '../model/employee.dart';
import '../model/invoiceEmployee.dart';
import 'employee_salary_entry.dart';
import 'employee_salary_update.dart';

class SingleEmployeeScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> employeeModel;

  const SingleEmployeeScreen({Key? key, required this.employeeModel})
      : super(key: key);

  @override
  _SingleEmployeeScreenState createState() =>
      _SingleEmployeeScreenState();
}

class _SingleEmployeeScreenState extends State<SingleEmployeeScreen> {

  int _balance = 0;
  int _due = 0;
  int _salary = 0;
  final _formKey = GlobalKey<FormState>();
  final salaryEditingController = new TextEditingController();
  bool isSalaryFieldOpened = false;


  @override
  void initState() {
    super.initState();
    _salary = int.parse(widget.employeeModel["salary"]);

    FirebaseFirestore.instance
        .collection('employees')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["name"].toString().toLowerCase() ==
            widget.employeeModel.get("name").toString().toLowerCase()) {
          setState(() {
            _salary = _salary -
                (int.parse(doc["salaryAdvanced"])) + (int.parse(doc["balance"]));
            if (_salary < 0) {
                _balance = 0;
                _due = -(_salary);
            } else {
                _due = 0;
                _balance = _salary;
            }
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeSalaryEntryScreen(employeeModel: widget.employeeModel)));
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
    Widget buildSingleItem( employee) =>
        Container(
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
                        employee["date"],
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
                        "Salary Advanced",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        employee["salaryAdvanced"],
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
                        "Salary Reloaded",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        employee["balance"],
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
                        employee["remarks"],
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
                        .collection('employees')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["name"] == employee["name"] && doc["invoice"] == employee["invoice"]){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmployeeSalaryUpdateScreen(
                                    employeeModel: employee,
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
                        .collection('employees')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["name"] == employee["name"] && doc["invoice"] == employee["invoice"]){
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
    FirebaseFirestore.instance.collection("employees");

    Widget _buildListView() {
      return StreamBuilder<QuerySnapshot>(
          stream: _collectionReference.snapshots().asBroadcastStream(),
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
                  element["name"].toString().toLowerCase() ==
                      widget.employeeModel.get("name"))
                      .map((QueryDocumentSnapshot<Object?> data) {
                    return buildSingleItem(data);
                  })
                ],
              );
            }
          });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Employee Name : ${widget.employeeModel["name"]}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Employee Name : ${widget.employeeModel["name"]}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Post : ${widget.employeeModel["post"]}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),

                    Text(
                      "Balance : $_balance TK",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Salary : ${widget.employeeModel["salary"]} TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Due : $_due TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            Expanded(child: _buildListView()),
          ],
        ),
      ),
      floatingActionButton: _getFAB(),
    );
  }



  void generatePdf() async {

    FirebaseFirestore.instance
        .collection('employees')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["name"].toString().toLowerCase() == widget.employeeModel.get("name").toString().toLowerCase()){


          final _list = <EmployeeItem>[];
          _list.add(new EmployeeItem(
            doc["date"],
            doc["salaryAdvanced"],
            doc["balance"],
            doc["remarks"],
          ));


          final _docList = [];
          _docList.add(doc);

          final invoice = InvoiceEmployee(_docList.first["name"], _docList.first["post"],
              _docList.first["salary"], _balance.toString(),_due.toString(), _list);
          final pdfFile =  PdfEmployee.generate(invoice);
        }
      }
    });


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Pdf Generated!!")));

  }

}
