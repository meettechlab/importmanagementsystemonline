import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsystemonline/model/coal_archive.dart';
import 'package:importmanagementsystemonline/screens/archive.dart';
import 'package:importmanagementsystemonline/screens/single_coal_lc_screen.dart';
import 'package:intl/intl.dart';
import '../model/coal.dart';
import '../model/company.dart';
import '../model/stone.dart';
import 'coal_lc_create_screen.dart';
import 'dashboard.dart';

class CoalLCListScreen extends StatefulWidget {
  const CoalLCListScreen({Key? key}) : super(key: key);

  @override
  _CoalLCListScreenState createState() => _CoalLCListScreenState();
}

class _CoalLCListScreenState extends State<CoalLCListScreen> {
  DateTime? _date;
  double _totalStock = 0.0;
  int _totalAmount = 0;

  bool? _process;
  int? _count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
    calculate();
  }

  void calculate() async {
    FirebaseFirestore.instance
        .collection('coals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["lc"] != "sale") {
          setState(() {
            _totalStock = double.parse(
                (_totalStock + double.parse(doc["ton"])).toStringAsFixed(3));
            _totalAmount = (_totalAmount + double.parse(doc["credit"])).floor();
          });
        } else {
          setState(() {
            _totalStock = double.parse(
                (_totalStock - double.parse(doc["ton"])).toStringAsFixed(3));
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
            width: 10,
            height: 20,
          ),
          Material(
            elevation: 5,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                10,
                10,
                10,
                10,
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
                    ? 'Pick Year'
                    : DateFormat('yyyy').format(_date!),
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );


    final addButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.red.shade800 : Colors.red,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          15,
         10,
          15,
         10,
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
              :   showDialog(
              context: context,
              builder: (BuildContext context)=>AlertDialog(
                title: Text("Confirm"),
                content: Text("Do you want to archive it?"),
                actions: [
                  IconButton(
                      icon: new Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  IconButton(
                      icon: new Icon(Icons.archive),
                      onPressed: () {
                        AddData();
                        Navigator.pop(context);
                      })
                ],
              )
          );;
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
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))),
                ],
              )
            : Text(
                'Archive',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Coal LC List'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Stock : $_totalStock Ton",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Total Purchase : $_totalAmount TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                pickDate,
                SizedBox(
                  width: 20,
                ),
                addButton,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: LCSearch());
                  },
                  child: Row(
                    children: [Text('Search By LC')],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: YearSearch());
                  },
                  child: Row(
                    children: [Text('Search By Year')],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Expanded(child: _buildListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CoalLCCreateScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("coals");

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
                        element["invoice"].toString().toLowerCase() == ("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget buildSingleItem(coal) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleCoalLCScreen(coalModel: coal)));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20,
                ),
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
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "LC",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      coal["lc"],
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
                IconButton(
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection('coals')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if (doc["lc"] == coal["lc"]) {
                          setState(() {
                            doc.reference.delete();
                          });
                        }
                      }
                    });

                    FirebaseFirestore.instance
                        .collection('companies')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if (doc["id"] == "coalstock" + coal["lc"]) {
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
              ],
            ),
          ),
        ),
      );

  void AddData() async {
    try {
      int _invoiceA  =  1;
      FirebaseFirestore.instance
          .collection('coalarchive')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc2 in querySnapshot.docs) {
          if (doc2["archiveName"].toString() ==
              DateFormat('yyyy').format(_date!) + " : " + "Purchase") {
            if (_invoiceA <= int.parse(doc2["archive"])) {
              _invoiceA = int.parse(doc2["archive"]) + 1;
            }
          }
        }
      });
    await  FirebaseFirestore.instance
          .collection('coals')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc["year"].toString().contains(DateFormat('yyyy').format(_date!)) &&doc["lc"].toString().toLowerCase() != "sale" ) {
            /*FirebaseFirestore.instance
                .collection('coalarchive')
                .get()
                .then((QuerySnapshot querySnapshot) {
              for (var doc in querySnapshot.docs) {
                if (!doc["archiveName"].toString().toLowerCase().contains("sale")) {
                  if (_invoiceA <= int.parse(doc["archive"])) {
                    _invoiceA = int.parse(doc["archive"]) + 1;
                  }
                }
              }*/

              var ref =
                  FirebaseFirestore.instance.collection("coalarchive").doc();
               CoalArchive coalModel = CoalArchive();
              coalModel.archive = _invoiceA.toString();
              coalModel.archiveName =
                  doc["year"].toString().split("-").last + " : " + "Purchase";
              coalModel.lc = doc["lc"];
              coalModel.date = doc["date"];
              coalModel.invoice = doc["invoice"];
              coalModel.supplierName = doc["supplierName"];
              coalModel.port = doc["port"];
              coalModel.ton = doc["ton"];
              coalModel.rate = doc["rate"];
              coalModel.totalPrice = doc["totalPrice"];
              coalModel.paymentType = doc["paymentType"];
              coalModel.paymentInformation = doc["paymentInformation"];
              coalModel.credit = doc["credit"];
              coalModel.debit = doc["debit"];
              coalModel.remarks = doc["remarks"];
              coalModel.year = doc["year"];
              coalModel.truckCount = doc["truckCount"];
              coalModel.truckNumber = doc["truckNumber"];
              coalModel.contact = doc["contact"];
              coalModel.docID = ref.id;
              ref.set(coalModel.toMap());
              _invoiceA = _invoiceA + 1;
              doc.reference.delete();
              print(_invoiceA);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("Data archived!!")));
        setState(() {
          _process = false;
          _count = 1;
          _date = null;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Something wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
        _date = null;
      });
    }
  }
}

class LCSearch extends SearchDelegate {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("coals");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
                      element["lc"]
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      element["invoice"].toString().toLowerCase() == ("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("lc");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SingleCoalLCScreen(coalModel: data)));
                  },
                  title: Text(lc),
                );
              })
            ]);
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
                        element["lc"]
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()) &&
                        element["invoice"].toString().toLowerCase() == ("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String lc = data.get("lc");
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleCoalLCScreen(coalModel: data)));
                    },
                    title: Text(lc),
                  );
                })
              ],
            );
          }
        });
  }
}

class YearSearch extends SearchDelegate {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("coals");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
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
                        element["year"]
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()) &&
                        element["invoice"].toString().toLowerCase() == ("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String lc = data.get("lc");
                  final String year = data.get("year");
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleCoalLCScreen(coalModel: data)));
                    },
                    title: Text(lc),
                    subtitle: Text(year),
                  );
                })
              ],
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
                        element["year"]
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()) &&
                        element["invoice"].toString().toLowerCase() == ("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String lc = data.get("lc");
                  final String year = data.get("year");
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleCoalLCScreen(coalModel: data)));
                    },
                    title: Text(lc),
                    subtitle: Text(year),
                  );
                })
              ],
            );
          }
        });
  }
}
