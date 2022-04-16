import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsystemonline/screens/stone_sale_screen.dart';



import '../model/lc.dart';
import '../model/stone.dart';
import 'coal_lc_list_screen.dart';
import 'coal_sale_screen.dart';
import 'company_list_screen.dart';
import 'employee_list_screen.dart';
import 'lc_list_screen.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

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
          'Dashboard',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
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
                  getImageButton(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LCListScreen()));
                  },
                      'assets/images/stone.jpg',
                      'Letter of Credit ( LC )'
                  ),

                  getImageButton(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StoneSaleScreen()));
                  },
                      'assets/images/stone.jpg',
                    'Stone Border Sale',
                  ),

                  getImageButton(() {
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => CrusherStockSScreen()));
                  },
                    'assets/images/crusher.jpg',
                    'Crusher Stock ( Shutarkandi )',
                  ),
                  getImageButton(() {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CrusherStockTScreen()));
                  },
                    'assets/images/crusher.jpg',
                    'Crusher Stock ( Tamabil )',
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getImageButton(() {
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => CrusherSaleSScreen()));
                  },
                      'assets/images/crusher.jpg',
                    'Crusher Sale ( Shutarkandi )',
                  ),

                  getImageButton(() {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CrusherSaleTScreen()));
                  },
                    'assets/images/crusher.jpg',
                    'Crusher Sale ( Tamabil )',
                  ),

                  getImageButton(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeListScreen()));
                  },
                    'assets/images/employee.jpg',
                    'Employees',
                  ),
                  getImageButton(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CoalLCListScreen()));
                  },
                    'assets/images/Coal.jpg',
                    'Coal Purchase',
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getImageButton(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CoalSaleScreen()));
                  },
                    'assets/images/Coal.jpg',
                    'Coal Sale',
                  ),

                  getImageButton(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyListScreen()));
                  },
                    'assets/images/company.jpg',
                    'Clients/Suppliers',
                  ),

                  getImageButton(() {
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => DailyCostScreen()));
                  },
                    'assets/images/profit.png',
                    'Daily Cost',
                  ),
                  getImageButton(() {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => NonLCScreen()));
                  },
                    'assets/images/profit.png',
                    'NON-LC Transaction',
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getImageButton(() {
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossScreen()));
                  },
                    'assets/images/profit.png',
                    'Profit / Loss',
                  ),

                ],
              ),
              SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }

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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
}
