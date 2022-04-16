import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsystemonline/screens/single_coal_lc_screen.dart';
import '../model/coal.dart';
import '../model/company.dart';
import '../model/stone.dart';
import 'coal_lc_create_screen.dart';

class CoalLCListScreen extends StatefulWidget {
  const CoalLCListScreen({Key? key}) : super(key: key);

  @override
  _CoalLCListScreenState createState() => _CoalLCListScreenState();
}

class _CoalLCListScreenState extends State<CoalLCListScreen> {
  double _totalStock = 0.0;
  double _totalAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculate();
  }

  void calculate() async {
    FirebaseFirestore.instance
        .collection('coals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["lc"] != "sale"){
          setState(() {
            _totalStock = (_totalStock + double.parse(doc["ton"]));
            _totalAmount = (_totalAmount + double.parse(doc["credit"]));
          });
        }else{
          setState(() {
            _totalStock = (_totalStock - double.parse(doc["ton"]));
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
        title: Text('Coal LC List'),
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

  Widget buildSingleItem(coal) => InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCoalLCScreen(coalModel: coal)));
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
                Text(
                  coal["lc"],
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection('coals')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if(doc["lc"] == coal["lc"]){
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
                        if(doc["id"] == "coalstock" + coal["lc"]){
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
                      element["invoice"].toString().toLowerCase()==("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("lc");
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCoalLCScreen(coalModel: data)));
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
                        element["invoice"]
                            .toString()
                            .toLowerCase()
                            ==("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String lc = data.get("lc");
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCoalLCScreen(coalModel: data)));
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
                        element["invoice"]
                            .toString()
                            .toLowerCase()
                            ==("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String lc = data.get("lc");
                  final String year = data.get("year");
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCoalLCScreen(coalModel: data)));
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
                        element["invoice"]
                            .toString()
                            .toLowerCase()
                            ==("1"))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String lc = data.get("lc");
                  final String year = data.get("year");
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCoalLCScreen(coalModel: data)));
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
