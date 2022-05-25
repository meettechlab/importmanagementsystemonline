import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/lc.dart';
import '../model/stone.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';
import 'individual_lc_history_screen.dart';
import 'lc_new_screen.dart';

class LCListScreen extends StatefulWidget {
  const LCListScreen({Key? key}) : super(key: key);

  @override
  _LCListScreenState createState() => _LCListScreenState();
}

class _LCListScreenState extends State<LCListScreen> {
  double _totalStockTamabil = 0.0;
  double _totalStockShutarkandi= 0.0;
  int _totalAmountTamabil = 0;
  int _totalAmountShutarkandi = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('lcs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
         if(doc["port"].toString().toLowerCase()=="tamabil"){
           setState(() {
             _totalStockTamabil = double.parse((_totalStockTamabil + double.parse(doc["cft"])).toStringAsFixed(3));
             _totalAmountTamabil = (_totalAmountTamabil + double.parse(doc["totalBalance"])).floor();
           });
         }else if(doc["port"].toString().toLowerCase()=="shutarkandi"){
           setState(() {
             _totalStockShutarkandi = double.parse((_totalStockShutarkandi + double.parse(doc["cft"])).toStringAsFixed(3));
             _totalAmountShutarkandi = (_totalAmountShutarkandi + double.parse(doc["totalBalance"])).floor();
           });
         }
      }
    });

    FirebaseFirestore.instance
        .collection('stones')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["port"].toString().toLowerCase()=="tamabil"){
          setState(() {
            _totalStockTamabil = double.parse((_totalStockTamabil - double.parse(doc["cft"])).toStringAsFixed(3));
          });
        }else if(doc["port"].toString().toLowerCase()=="shutarkandi"){
          setState(() {
            _totalStockShutarkandi = double.parse((_totalStockShutarkandi - double.parse(doc["cft"])).toStringAsFixed(3));
          });
        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('LC List'),
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
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tamabil Stock : $_totalStockTamabil CFT",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Tamabil Total Purchase : $_totalAmountTamabil TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shutarkandi Stock : $_totalStockShutarkandi Ton",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Shutarkandi Total Purchase : $_totalAmountShutarkandi TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LCNewScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("lcs");

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
                element["invoice"]
                    .toString()
                    .toLowerCase()
                    ==("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget buildSingleItem(lc) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      IndividualLCHistoryScreen(lcModel: lc)));
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
                    Text(
                      "Date",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      lc["date"],
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
                      "LC",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      lc["lcNumber"],
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
                      lc["port"],
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
                      "Seller Name",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      lc["sellerName"],
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
                        .collection('lcs')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["lcNumber"] == lc["lcNumber"]){
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
                        if(doc["id"] == "stonestock" + lc["lcNumber"]){
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
}

class LCSearch extends SearchDelegate {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("lcs");


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
              element["lcNumber"]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
                  element["invoice"].toString().toLowerCase()==("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("lcNumber");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IndividualLCHistoryScreen(lcModel: data)));                  },
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
            return ListView(children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
              element["lcNumber"]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
                  element["invoice"].toString().toLowerCase()==("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("lcNumber");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IndividualLCHistoryScreen(lcModel: data)));                  },
                  title: Text(lc),
                );
              })
            ]);
          }
        });
  }
}

class YearSearch extends SearchDelegate {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("lcs");

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
              element["year"]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
                  element["invoice"].toString().toLowerCase()==("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("lcNumber");
                final String year = data.get("year");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IndividualLCHistoryScreen(lcModel: data)));                  },
                  title: Text(lc),
                  subtitle: Text(year),
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
            return ListView(children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
              element["year"]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
                  element["invoice"].toString().toLowerCase()==("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("lcNumber");
                final String year = data.get("year");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IndividualLCHistoryScreen(lcModel: data)));                  },
                  title: Text(lc),
                  subtitle: Text(year),
                );
              })
            ]);
          }
        });
  }
}
