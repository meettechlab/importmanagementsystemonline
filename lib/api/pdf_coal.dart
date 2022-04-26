import 'dart:io';

import 'package:importmanagementsystemonline/api/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/invoiceCoal.dart';

class PdfCoal {
  static Future<File> generate(InvoiceCoal invoice, bool isSale) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a3,
      build: (context) => [
        buildFooter(),
        buildTitle(invoice, isSale),
        buildInvoice(invoice, isSale),
        Divider(),
        buildTotal(invoice, isSale),
      ],
    //  footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(
        "Coal" + DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()) + ".pdf",
        pdf);
  }

  static Widget buildTitle(InvoiceCoal invoice, bool isSale) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Date : ' + DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            style: TextStyle(
              fontSize: 10,
            )),
        SizedBox(height: 2 * PdfPageFormat.cm),
        isSale
            ? Text('')
            : Text('LC number : ' + invoice.lc,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        isSale ? Text('') : SizedBox(height: 0.8 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(InvoiceCoal invoice, bool isSale) {
    final headers = [
      'Date',
      'Truck Number',
      'Supplier Name',
      'Ton',
      'Port',
      'Remarks'
    ];

    final headersSale = [
      'Date',
      'Truck Number',
      'Buyer Name',
      'Port',
      'Ton',
      'Rate',
      'Total Price',
      'Remarks'
    ];

    final data = invoice.items.map((item) {
      return [
        item.date,
        item.truckNumber,
        item.buyerName,
        item.ton,
        item.port,
        item.remarks
      ];
    }).toList();

    final dataSale = invoice.items.map((item) {
      return [
        item.date,
        item.truckNumber,
        item.buyerName,
        item.port,
        item.ton,
        item.rate,
        item.total,
        item.remarks
      ];
    }).toList();

    return Table.fromTextArray(
      headers: isSale ? headersSale : headers,
      data: isSale ? dataSale : data,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 20,
      cellAlignments: isSale
          ? {
              0: Alignment.centerLeft,
              1: Alignment.centerRight,
              2: Alignment.centerRight,
              3: Alignment.centerRight,
              4: Alignment.centerRight,
              5: Alignment.centerRight,
              6: Alignment.centerRight,
              7: Alignment.centerRight,
            }
          : {
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

            },
    );
  }

  static Widget buildTotal(InvoiceCoal invoice, bool isSale) {
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
                        title: 'Total Stock',
                        value: invoice.stock,
                        unite: true),
                    buildText(
                        title: "Total Amount",
                        value: invoice.amount,
                        unite: true),
                    isSale? Text(""): buildText(
                        title: 'Rate',
                        value: invoice.rate,
                        unite: true),
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
