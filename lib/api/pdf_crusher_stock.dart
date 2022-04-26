import 'dart:io';

import 'package:importmanagementsystemonline/api/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../model/invoiceCrusherStock.dart';

class PdfCrusherStock {
  static Future<File> generate(InvoiceCrusherStock invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a3,
      build: (context) => [
        buildFooter(),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
     // footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(
        "crusher_stock" +
            DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()) +
            ".pdf",
        pdf);
  }

  static Widget buildTitle(InvoiceCrusherStock invoice) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Date : ' + DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            style: TextStyle(
              fontSize: 10,
            )),
        SizedBox(height: 2 * PdfPageFormat.cm),
        Text('Port : ' + invoice.items[0].port,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(InvoiceCrusherStock invoice) {
    final headers = [
      'Date',
      'Truck Count',
      'Supplier Name',
      'CFT',
      'Rate',
      'Total Price',
      '3/4 ',
      '16 mm',
      '1/2',
      '5/10',
      'Total Weight',
      'Extra',
      'Remarks'
    ];

    final data = invoice.items.map((item) {
      return [
        item.date,
        item.truckCount,
        item.buyerName,
        item.cft,
        item.rate,
        item.totalPrice,
        item.threeToFour,
        item.sixteen,
        item.half,
        item.fiveToTen,
        item.totalWeight,
        item.extra,
        item.remarks
      ];
    }).toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerRight,
        9: Alignment.centerRight,
        10: Alignment.centerRight,
        11: Alignment.centerRight,
        12: Alignment.centerRight,
        13: Alignment.centerRight,
        14: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(InvoiceCrusherStock invoice) {
    final netTotalList = invoice.items.map((item) => item.totalWeight).toList();
    final netSaleList = invoice.items.map((item) => item.totalPrice).toList();
    double _netTotal = 0.0;
    double _netSale = 0.0;
    for (int i = 0; i < netTotalList.length; i++) {
      _netTotal = _netTotal + double.parse(netTotalList[i]);
      _netSale = _netTotal + double.parse(netSaleList[i]);
    }

    return Container(
        alignment: Alignment.centerRight,
        child: Row(children: [
          Spacer(flex: 6),
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                        title: 'Total Net Weight',
                        value: _netTotal.toString(),
                        unite: true),
                    buildText(
                        title: "Total Net Amount",
                        value: _netSale.toString(),
                        unite: true)
                  ]))
        ]));
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
        width: width,
        child: Row(children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ]));
  }

  static Widget buildFooter() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

        buildFooterText(
            title: '',
            value: 'M/S Priya Enterprise coal & stone importer & distributor', isBold: true),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Contact :', value: '+8801711-362096 , +8801712-403015 , +8801716-882817', isBold: false),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Address :', value: 'Laldighirpar, Sylhet', isBold: false),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Email :', value: 'sawonseu@gmail.com', isBold: false),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Developed By :', value: 'MeetTech Lab ', isBold: false),
        buildFooterText(title: 'Contact :', value: '+8801755-460159 ', isBold: false),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Divider(),
      ]);

  static buildFooterText({required String title, required String value , required bool isBold}) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: style),
          SizedBox(width: 2 * PdfPageFormat.mm),
          isBold ?Text(value, style:  style): Text(value),
        ]);
  }
}
