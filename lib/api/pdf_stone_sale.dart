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
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
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
      'Truck Count',
      'Truck Number',
      'Port',
      'Buyer Name',
      'Buyer Contact',
      'CFT',
      'Rate',
      'Total',
      'Payment Type',
      'Payment Info',
      'Remarks'
    ];

    final data = invoice.items.map((item) {
      return [
        item.date,
        item.truckCount,
        item.truckNumber,
        item.port,
        item.buyerName,
        item.buyerContact,
        item.cft,
        item.rate,
        item.total,
        item.paymentType,
        item.paymentInfo,
        item.remarks
      ];
    }).toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
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

  static Widget buildFooter(InvoiceStoneSale invoice) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Divider(),
        SizedBox(height: 2 * PdfPageFormat.mm),
        buildFooterText(
            title: 'Organisation :',
            value: 'M/S Priya Enterprise & B.N. Traders'),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Contact :', value: '+8801711-362096'),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Address :', value: 'Laldighirpar, Sylhet'),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Developed By :', value: 'MeetTech Lab '),
      ]);

  static buildFooterText({required String title, required String value}) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: style),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(value),
        ]);
  }
}
