import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/lc.dart';
import '../model/stone.dart';
import 'company_list_screen.dart';
import 'crusher_sale_t_screen.dart';
import 'crusher_stock_s_screen.dart';
import 'daily_coal_screen.dart';
import 'daily_crusher_screen.dart';
import 'daily_entry_screen.dart';
import 'daily_stone_screen.dart';
import 'dashboard.dart';

class DailyCostScreen extends StatefulWidget {
  const DailyCostScreen({Key? key}) : super(key: key);

  @override
  _DailyCostScreenState createState() => _DailyCostScreenState();
}

class _DailyCostScreenState extends State<DailyCostScreen> {
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
          'Daily Cost',
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
                              builder: (context) => DailyCoalScreen()));
                    },
                    'assets/images/Coal.jpg',
                    'Coal',
                  ),
                  getImageButton(
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DailyStoneScreen()));
                    },
                    'assets/images/stone.jpg',
                    'Stone',
                  ),
                  getImageButton(
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DailyCrusherScreen()));
                    },
                    'assets/images/crusher.jpg',
                    'Crusher',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DailyEntryScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
