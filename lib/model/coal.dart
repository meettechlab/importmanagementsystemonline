
import 'package:cloud_firestore/cloud_firestore.dart';

class Coal {
    String? lc;
    String? date;
    String? invoice;
    String? supplierName;
    String? port;
    String? ton;
    String? rate;
    String? totalPrice;
    String? paymentType;
    String? paymentInformation;
    String? credit;
    String? debit;
    String? remarks;
    String? year;
    String? truckCount;
    String? truckNumber;
    String? contact;
    String? docID;


  Coal({
    this.lc,
    this.date,
    this.invoice,
    this.supplierName,
    this.port,
    this.ton,
    this.rate,
    this.totalPrice,
    this.paymentType,
    this.paymentInformation,
    this.credit,
    this.debit,
    this.remarks,
    this.year,
    this.truckCount,
    this.truckNumber,
    this.contact,
    this.docID,

  });


  factory Coal.fromMap(map){
    return Coal(
      lc: map['lc'],
      date: map['date'],
      invoice: map['invoice'],
      supplierName: map['supplierName'],
      port: map['port'],
      ton: map['ton'],
      rate: map['rate'],
      totalPrice: map['totalPrice'],
      paymentType: map['paymentType'],
      paymentInformation: map['paymentInformation'],
      credit: map['credit'],
      debit: map['debit'],
      remarks: map['remarks'],
      year: map['year'],
      truckCount: map['truckCount'],
      truckNumber: map['truckNumber'],
      contact: map['contact'],
      docID: map['docID'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lc': lc,
      'date': date,
      'invoice': invoice,
      'supplierName': supplierName,
      'port': port,
      'ton': ton,
      'rate': rate,
      'totalPrice': totalPrice,
      'paymentType': paymentType,
      'paymentInformation': paymentInformation,
      'credit': credit,
      'debit': debit,
      'remarks': remarks,
      'year': year,
      'truckCount': truckCount,
      'truckNumber': truckNumber,
      'contact': contact,
      'docID': docID,
    };
  }
}
