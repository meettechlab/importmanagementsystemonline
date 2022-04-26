import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/lc.dart';
import '../model/nonstone.dart';
import '../model/stone.dart';
import 'dashboard.dart';
import 'individual_lc_entry_screen.dart';
import 'non_stone_create_screen.dart';
import 'non_stone_history_screen.dart';

class NonStoneListScreen extends StatefulWidget {
  const NonStoneListScreen({Key? key}) : super(key: key);

  @override
  _NonStoneListScreenState createState() => _NonStoneListScreenState();
}

class _NonStoneListScreenState extends State<NonStoneListScreen> {
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
        title: Text('Non-LC Stone List'),
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
              MaterialPageRoute(builder: (context) => NonStoneCreateScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("nonstone");

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
                  builder: (context) => NonStoneHistoryScreen(lcModel: lc)));

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
                  lc["lcNumber"],
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
                            .collection('nonstone')
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
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  void AddData( nonStone) {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('nonstone')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if(doc["lcNumber"] == nonStone["lcNumber"]){
            final ref = FirebaseFirestore.instance.collection("lcs").doc();
            LC _lcModel = LC();
   _lcModel.date =  doc["date"];
        _lcModel.truckCount =   doc["truckCount"];
        _lcModel.truckNumber =      doc["truckNumber"];
        _lcModel.invoice = doc["invoice"];
        _lcModel.port =  doc["port"];
        _lcModel.cft =   doc["cft"];
        _lcModel.rate =    doc["rate"];
        _lcModel.stockBalance =     doc["stockBalance"];
        _lcModel.sellerName =    doc["sellerName"];
        _lcModel.sellerContact =     doc["sellerContact"];
        _lcModel.paymentType =    doc["paymentType"];
        _lcModel.paymentInformation =   doc["paymentInformation"];
        _lcModel.purchaseBalance =    doc["purchaseBalance"];
        _lcModel.lcOpenPrice =   doc["lcOpenPrice"];
        _lcModel.dutyCost = doc["dutyCost"];
        _lcModel.speedMoney =   doc["speedMoney"];
        _lcModel.remarks =     doc["remarks"];
        _lcModel.lcNumber =      lcNumberEditingController.text;
        _lcModel.totalBalance =      doc["totalBalance"];
        _lcModel.year =      doc["year"];
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
