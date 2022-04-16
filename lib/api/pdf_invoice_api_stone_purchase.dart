import 'dart:io';
import 'package:importmanagementsystemonline/api/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/invoiceStonePurchase.dart';

class PdfInvoiceApiStonePurchase {
  static Future<File> generate(InvoiceStonePurchase invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(
        "stone_purchase" +
            DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()) +
            ".pdf",
        pdf);
  }

  static Widget buildTitle(InvoiceStonePurchase invoice) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Date : ' + DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            style: TextStyle(
              fontSize: 10,
            )),
        SizedBox(height: 2 * PdfPageFormat.cm),
        Text('LC number : ' + invoice.lcNumber,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Supplier Name : ' + invoice.sellerName,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text('Supplier Contact : ' + invoice.sellerContact,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ]),
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rate : ' + invoice.rate,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text('LC Open Price : ' + invoice.lcOpenPrice,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ]),
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Duty Cost : ' + invoice.dutyCost,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text('Speed Money : ' + invoice.speedMoney,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ]),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(InvoiceStonePurchase invoice) {
    final headers = [
      'Date',
      'Truck Count',
      'Truck Number',
      'Port',
      'CFT',
      'Remarks'
    ];

    final data = invoice.items.map((item) {
      final _totalPurchase =
          ((double.parse(item.cft) * (double.parse(invoice.rate)) +
                  double.parse(invoice.lcOpenPrice) +
                  double.parse(invoice.dutyCost) +
                  double.parse(invoice.speedMoney))
              .toString());

      return [
        item.date,
        item.truckCount,
        item.truckNumber,
        item.port,
        item.cft,
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
      },
    );
  }

  static Widget buildTotal(InvoiceStonePurchase invoice) {
    final netTotalList = invoice.items.map((item) => item.cft).toList();
    double _netTotal = 0.0;
    for (int i = 0; i < netTotalList.length; i++) {
      _netTotal = _netTotal + double.parse(netTotalList[i]);
    }
    final _netPurchase = (_netTotal * double.parse(invoice.rate)) +
        double.parse(invoice.lcOpenPrice) +
        double.parse(invoice.dutyCost) +
        double.parse(invoice.speedMoney);

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
                        title: 'Total Stock ( Purchased )',
                        value: _netTotal.toString(),
                        unite: true),
                    buildText(
                        title: "Total Cost",
                        value: _netPurchase.toString(),
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

  static Widget buildFooter(InvoiceStonePurchase invoice) =>
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
