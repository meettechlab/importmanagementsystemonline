import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsystemonline/screens/coal_lc_list_screen.dart';
import 'package:importmanagementsystemonline/screens/coal_sale_screen.dart';
import 'package:importmanagementsystemonline/screens/crusher_sale_s_screen.dart';
import 'package:importmanagementsystemonline/screens/crusher_stock_t_screen.dart';
import 'package:importmanagementsystemonline/screens/daily_coal_screen.dart';
import 'package:importmanagementsystemonline/screens/daily_crusher_screen.dart';
import 'package:importmanagementsystemonline/screens/daily_entry_screen.dart';
import 'package:importmanagementsystemonline/screens/daily_stone_screen.dart';
import 'package:importmanagementsystemonline/screens/employee_list_screen.dart';
import 'package:importmanagementsystemonline/screens/lc_list_screen.dart';
import 'package:importmanagementsystemonline/screens/stone_sale_screen.dart';

import '../model/lc.dart';
import '../model/stone.dart';
import 'company_list_screen.dart';
import 'crusher_sale_t_screen.dart';
import 'crusher_stock_s_screen.dart';
import 'dashboard.dart';
import 'non_coal_list_screen.dart';
import 'non_stone_list_screen.dart';

class NonLCScreen extends StatefulWidget {
  const NonLCScreen({Key? key}) : super(key: key);

  @override
  _NonLCScreenState createState() => _NonLCScreenState();
}

class _NonLCScreenState extends State<NonLCScreen> {
  double _totalStock = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget getImageButton(VoidCallback action, String url, String buttonText) =>
        Material(
          color: Colors.blue,
          elevation: 5,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
            splashColor: Colors.black26,
            onTap: action,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ink.image(
                  image: AssetImage(
                    url,
                  ),
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 5,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Non-LC',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
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
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getImageButton(
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NonCoalListScreen()));
                    },
                    'assets/images/Coal.jpg',
                    'Non-LC Coal',
                  ),
                  getImageButton(
                    () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => NonStoneListScreen()));
                    },
                    'assets/images/stone.jpg',
                    'Non-LC Stone',
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
