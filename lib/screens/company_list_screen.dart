import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsystemonline/screens/single_company_screen.dart';


import '../model/company.dart';
import 'create_company_screen.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
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
        title: Text(
            'Clients/Suppliers List'
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: (){
                    showSearch(context: context, delegate: CompanySearch());
                  },
                  child: Row(
                    children: [
                      Text('Search By Name')
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildListView()),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateCompanyScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

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


  Widget buildSingleItem(company) => InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCompanyScreen(companyModel: company,)));
    },
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Text(
              company["name"],
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
              onPressed: (){

                FirebaseFirestore.instance
                    .collection('companies')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if(doc["name"] == company["name"]){
                      setState(() {
                        doc.reference.delete();
                      });
                    }
                  }
                });
              },
              icon: Icon(Icons.delete, color: Colors.red,),
            )
          ],
        ),
      ),
    ),
  );
}



class CompanySearch extends SearchDelegate{


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("companies");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query = '';
      }, icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        )
    );
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
              element["name"]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
                  element["invoice"].toString().toLowerCase()==("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("name");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>  SingleCompanyScreen(companyModel: data)));
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
            return ListView(children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
              element["name"]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
                  element["invoice"].toString().toLowerCase()==("1"))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String lc = data.get("name");
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>  SingleCompanyScreen(companyModel: data)));
                  },
                  title: Text(lc),
                );
              })
            ]);
          }
        });
  }

}
