import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import '../model/coal.dart';
import '../model/noncoal.dart';
import '../model/stone.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';
import 'non_coal_create_screen.dart';
import 'non_coal_history_screen.dart';

class NonCoalListScreen extends StatefulWidget {
  const NonCoalListScreen({Key? key}) : super(key: key);

  @override
  _NonCoalListScreenState createState() => _NonCoalListScreenState();
}

class _NonCoalListScreenState extends State<NonCoalListScreen> {
  final _formKey = GlobalKey<FormState>();
  final lcNumberEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Non-LC Coal List'),
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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: _buildListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NonCoalCreateScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("noncoal");

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

  Widget buildSingleItem( lc) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NonCoalHistoryScreen(
                        coalModel: lc,
                      )));
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
                  lc["lc"],
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('noncoal')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          for (var doc in querySnapshot.docs) {
                            if(doc["lc"] == lc["lc"]){
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
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => new AlertDialog(
                                  title:
                                      new Text('Enter the LC number to Save'),
                                  content: new Form(
                                    key: _formKey,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: TextFormField(
                                            cursorColor: Colors.blue,
                                            autofocus: false,
                                            controller:
                                                lcNumberEditingController,
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return ("LC Number cannot be empty!!");
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              lcNumberEditingController.text =
                                                  value!;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                20,
                                                15,
                                                20,
                                                15,
                                              ),
                                              labelText: 'LC Number',
                                              labelStyle:
                                                  TextStyle(color: Colors.blue),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                              ),
                                            ))),
                                  ),
                                  actions: <Widget>[
                                    new IconButton(
                                        icon: new Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    new IconButton(
                                        icon: new Icon(Icons.save),
                                        onPressed: () {
                                          AddData(lc);
                                        })
                                  ],
                                ));
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.red,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  void AddData( nonCoal ) {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('noncoal')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if(doc["lc"] == nonCoal["lc"]){
            final ref = FirebaseFirestore.instance.collection("coals").doc();
            Coal _lcModel = Coal();
              _lcModel.lc =   lcNumberEditingController.text;
        _lcModel.date = doc["date"];
        _lcModel.invoice =   doc["invoice"];
        _lcModel.supplierName =   doc["supplierName"];
        _lcModel.port =    doc["port"];
        _lcModel.ton =  doc["ton"];
        _lcModel.rate =   doc["rate"];
        _lcModel.totalPrice =  doc["totalPrice"];
        _lcModel.paymentType =   doc["paymentType"];
        _lcModel.paymentInformation =   doc["paymentInformation"];
        _lcModel.credit =   doc["credit"];
        _lcModel.debit =   doc["debit"];
                _lcModel.remarks =    doc["remarks"];
        _lcModel.year = doc["year"];
        _lcModel.truckCount =    doc["truckCount"];
        _lcModel.truckNumber =     doc["truckNumber"];
        _lcModel.contact =     doc["contact"];
        _lcModel.docID = ref.id;
         ref.set(_lcModel.toMap());


         doc.reference.delete();
        }
        }
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text("LC moved!!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
    }
  }
}
