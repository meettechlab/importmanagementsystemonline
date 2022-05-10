import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/pdf_daily.dart';
import '../model/daily.dart';
import '../model/invoiceDaily.dart';
import '../model/stone.dart';
import 'daily_entry_screen.dart';
import 'daily_update_screen.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';

class DailyCrusherScreen extends StatefulWidget {
  const DailyCrusherScreen({Key? key}) : super(key: key);

  @override
  _DailyCrusherScreenState createState() => _DailyCrusherScreenState();
}

class _DailyCrusherScreenState extends State<DailyCrusherScreen> {
  int _totalCost = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('daily')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["invoice"].toString().toLowerCase().contains("crusher")) {
          setState(() {
            _totalCost = (_totalCost + double.parse(doc["totalBalance"])).floor();
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DailyEntryScreen()));
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Daily Crusher Cost'),
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
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Daily Cost : $_totalCost TK",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Expanded(child: _buildListView()),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }

  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("daily");

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
                    element["invoice"].toString().toLowerCase().contains("crusher"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget buildSingleItem( daily) => Container(
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
                      daily["date"],
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
                      "Transport Cost",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["transport"],
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
                      "Unload Cost",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["unload"],
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
                      "Depo Rent Cost",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["depoRent"],
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
                      "Koipot",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["koipot"],
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
                      "Stone Crafting",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["stoneCrafting"],
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
                      "Diesel Cost",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["disselCost"],
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
                      "Gris Cost",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["grissCost"],
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
                      "Mobil Cost",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["mobilCost"],
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
                      "Extra",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["extra"],
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
                      "Total",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      daily["totalBalance"],
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
                      daily["remarks"],
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
                        .collection('daily')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["invoice"].toString().toLowerCase()== daily["invoice"].toString().toLowerCase()){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DailyUpdateScreen(
                                    dailyModel: daily,
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
                        .collection('daily')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["invoice"].toString().toLowerCase()== daily["invoice"].toString().toLowerCase()){
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

  void generatePdf() async {
    final _list = <DailyItem>[];
    final _docList = [];


    FirebaseFirestore.instance
        .collection('daily').orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["invoice"].toString().toLowerCase().contains("crusher")){

          _list.add(new DailyItem(
            doc["date"],
            doc["transport"],
            doc["unload"],
            doc["depoRent"],
            doc["koipot"],
            doc["stoneCrafting"],
            doc["disselCost"],
            doc["grissCost"],
            doc["mobilCost"],
            doc["extra"],
            doc["totalBalance"],
            doc["remarks"],
          ));

          _docList.add(doc);


        }
      }
      final invoice = InvoiceDaily(_totalCost.toString(), _docList.first["invoice"].toString(), _list);
      final pdfFile =  PdfDaily.generate(invoice);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
