import 'dart:io';
import 'package:importmanagementsystemonline/api/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/invoiceStoneSale.dart';

class PdfStoneSale {
  static Future<File> generate(InvoiceStoneSale invoice) async {
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
    //  footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(
        "stone_sale" +
            DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()) +
            ".pdf",
        pdf);
  }

  static Widget buildTitle(InvoiceStoneSale invoice) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Date : ' + DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            style: TextStyle(
              fontSize: 10,
            )),
        SizedBox(height: 2 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(InvoiceStoneSale invoice) {
    final headers = [
      'Date',

      'Truck NO.',
      'Port',
      'Buyer Name',

      'CFT',
      'Rate',
      'Total',
      'Pay. Type',

      'Remarks'
    ];

    final data = invoice.items.map((item) {
      return [
        item.date,

        item.truckNumber,
        item.port,
        item.buyerName,

        item.cft,
        item.rate,
        item.total,
        item.paymentType,

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
      },
    );
  }

  static Widget buildTotal(InvoiceStoneSale invoice) {
    final netTotalList = invoice.items.map((item) => item.cft).toList();
    final netSaleList = invoice.items.map((item) => item.total).toList();
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
                        title: 'Total Stock ( Sold )',
                        value: _netTotal.toString(),
                        unite: true),
                    buildText(
                        title: "Total Cost",
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
