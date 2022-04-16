import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/pdf_company.dart';
import '../model/company.dart';
import '../model/invoiceCompany.dart';
import 'company_payment_screen.dart';
import 'company_update_screen.dart';

class SingleCompanyScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> companyModel;

  const SingleCompanyScreen({Key? key, required this.companyModel})
      : super(key: key);

  @override
  _SingleCompanyScreenState createState() => _SingleCompanyScreenState();
}

class _SingleCompanyScreenState extends State<SingleCompanyScreen> {
  double _due = 0.0;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('companies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["name"].toString().toLowerCase() ==
            widget.companyModel.get("name").toString().toLowerCase()) {
          setState(() {
            _due = (_due - double.parse(doc["credit"]) + double.parse(doc["debit"]));
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
                      builder: (context) => CompanyPaymentScreen(
                          companyModel: widget.companyModel)));
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
    Widget buildSingleItem( company) => Container(
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
                        company["date"],
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
                        "Credit",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company["credit"],
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
                        "Debit",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company["debit"],
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
                        company["paymentTypes"],
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
                        "Payment Information",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company["paymentInfo"],
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
                        company["remarks"],
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  (company.id == "check")
                      ? IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('companies')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                if(doc["name"] == company["name"] && doc["invoice"] == company["invoice"]){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CompanyUpdateScreen(
                                                companyModel: company,
                                              )));
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        )
                      : Text(""),
                  (company.id == "check")
                      ? IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('companies')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                if(doc["name"] == company["name"] && doc["invoice"] == company["invoice"]){
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
                        )
                      : Text(""),
                ],
              ),
            ),
          ),
        );


    final CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection("companies");

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
                      widget.companyModel.get("name"))
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
        title: Text("Client/Supplier Name : ${widget.companyModel.get("name")}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Client/Supplier Name : ${widget.companyModel.get("name")}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Contact : ${widget.companyModel.get("contact")}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Address : ${widget.companyModel.get("address")}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
        .collection('companies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["name"].toString().toLowerCase() == widget.companyModel.get("name").toString().toLowerCase()){


          final _list = <CompanyItem>[];
          _list.add(new CompanyItem(
              doc["date"],
              doc["debit"],
              doc["credit"],
              doc["paymentTypes"],
              doc["paymentInfo"],
              doc["remarks"],));


          final _docList = [];
          _docList.add(doc);

          final invoice = InvoiceCompany(_docList.first["name"], _docList.first["contact"],
              _docList.first["address"],_due.toString(), _list);
          final pdfFile =  PdfCompany.generate(invoice);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
