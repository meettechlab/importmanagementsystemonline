
class CStock {
    String? invoice;
    String? date;
    String? truckCount;
    String? port;
    String? ton;
    String? cft;
    String? threeToFour;
    String? oneToSix;
    String? half;
    String? fiveToTen;
    String? totalBalance;
    String? extra;
    String? remarks;
    String? supplierName;
    String? supplierContact;
    String? year;
    String? rate;
    String? price;
    String? truckNumber;
    String? docID;

  CStock({
      this.invoice,
      this.date,
      this.truckCount,
      this.port,
      this.ton,
      this.cft,
      this.threeToFour,
      this.oneToSix,
      this.half,
      this.fiveToTen,
      this.totalBalance,
      this.extra,
      this.remarks,
      this.supplierName,
      this.supplierContact,
      this.year,
      this.rate,
      this.price,
      this.truckNumber,
    this.docID
  });



  factory CStock.fromMap(map){
    return CStock(
      invoice: map['invoice'],
      date: map['date'],
      truckCount: map['truckCount'],
      port: map['port'],
      ton: map['ton'],
      cft: map['cft'],
      threeToFour: map['threeToFour'],
      oneToSix: map['oneToSix'],
      half: map['half'],
      fiveToTen: map['fiveToTen'],
      totalBalance: map['totalBalance'],
      extra: map['extra'],
      remarks: map['remarks'],
      supplierName: map['supplierName'],
      supplierContact: map['supplierContact'],
      year: map['year'],
      rate: map['rate'],
      price: map['price'],
      truckNumber: map['truckNumber'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice': invoice,
      'date': date,
      'truckCount': truckCount,
      'port': port,
      'ton': ton,
      'cft': cft,
      'threeToFour': threeToFour,
      'oneToSix': oneToSix,
      'half': half,
      'fiveToTen': fiveToTen,
      'totalBalance': totalBalance,
      'extra': extra,
      'remarks': remarks,
      'supplierName': supplierName,
      'supplierContact': supplierContact,
      'year': year,
      'rate': rate,
      'price': price,
      'truckNumber': truckNumber,
      'docID': docID
    };
  }
}
