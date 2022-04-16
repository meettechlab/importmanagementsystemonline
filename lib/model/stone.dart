
class Stone {
    String? date;
    String? truckCount;
    String? truckNumber;
    String? invoice;
    String? port;
    String? cft;
    String? rate;
    String? buyerName;
    String? buyerContact;
    String? paymentType;
    String? paymentInformation;
    String? totalSale;
    String? remarks;
    String? stock;
    String? year;
    String? docID;



  Stone({
      this.date,
      this.truckCount,
      this.truckNumber,
      this.invoice,
      this.port,
      this.cft,
      this.rate,
      this.paymentType,
      this.paymentInformation,
      this.remarks,
      this.buyerName,
      this.buyerContact,
      this.totalSale,
      this.stock,
      this.year,
    this.docID

  });



  factory Stone.fromMap(map){
    return Stone(
      date: map['date'],
      truckCount: map['truckCount'],
      truckNumber: map['truckNumber'],
      invoice: map['invoice'],
      port: map['port'],
      cft: map['cft'],
      rate: map['rate'],
      paymentType: map['paymentType'],
      paymentInformation: map['paymentInformation'],
      remarks: map['remarks'],
      buyerName: map['buyerName'],
      buyerContact: map['buyerContact'],
      totalSale: map['totalSale'],
      stock: map['stock'],
      year: map['year'],
        docID: map['docID']

    );
  }

  Map<String, dynamic> toMap() {
    return {

      'date': date,
      'truckCount': truckCount,
      'truckNumber': truckNumber,
      'invoice': invoice,
      'port': port,
      'cft': cft,
      'rate': rate,
      'paymentType': paymentType,
      'paymentInformation': paymentInformation,
      'remarks': remarks,
      'buyerName': buyerName,
      'buyerContact': buyerContact,
      'totalSale': totalSale,
      'stock': stock,
      'year': year,
      'docID': docID

    };
  }
}
