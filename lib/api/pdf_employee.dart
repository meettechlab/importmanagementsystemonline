import 'dart:io';
import 'package:importmanagementsystemonline/api/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/invoiceEmployee.dart';

class PdfEmployee {
  static Future<File> generate(InvoiceEmployee invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
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
        "employee" +
            DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()) +
            ".pdf",
        pdf);
  }

  static Widget buildTitle(InvoiceEmployee invoice) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Date : ' + DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            style: TextStyle(
              fontSize: 10,
            )),
        SizedBox(height: 2 * PdfPageFormat.cm),
        Text('Name : ' + invoice.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Post : ' + invoice.post,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text('Salary : ' + invoice.salary,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ]),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(InvoiceEmployee invoice) {
    final headers = ['Date', 'Salary Advanced', 'Salary Reloaded', 'Remarks'];

    final data = invoice.items.map((item) {
      return [
        item.date,
        item.salaryAdvanced,
        item.salaryReloaded,
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
      },
    );
  }

  static Widget buildTotal(InvoiceEmployee invoice) {
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
                        title: 'Balance', value: invoice.balance, unite: true),
                    buildText(title: "Due", value: invoice.due, unite: true)
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
