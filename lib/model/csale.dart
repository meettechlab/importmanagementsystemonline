
class CSale {
    String? invoice;
    String? date;
    String? truckCount;
    String? cft;
    String? rate;
    String? price;
    String? threeToFour;
    String? oneToSix;
    String? half;
    String? fiveToTen;
    String? remarks;
    String? port;
    String? buyerName;
    String? buyerContact;
    String? year;
    String? truckNumber;
    String? docID;

  CSale({
    this.invoice,
    this.date,
    this.truckCount,
    this.cft,
    this.rate,
    this.price,
    this.threeToFour,
    this.oneToSix,
    this.half,
    this.fiveToTen,
    this.remarks,
    this.port,
    this.buyerName,
    this.buyerContact,
    this.year,
    this.truckNumber,
    this.docID
  });


  factory CSale.fromMap(map){
    return CSale(
      invoice: map['invoice'],
      date: map['date'],
      truckCount: map['truckCount'],
      cft: map['cft'],
      rate: map['rate'],
      price: map['price'],
      threeToFour: map['threeToFour'],
      oneToSix: map['oneToSix'],
      half: map['half'],
      fiveToTen: map['fiveToTen'],
      remarks: map['remarks'],
      port: map['port'],
      buyerName: map['buyerName'],
      buyerContact: map['buyerContact'],
      year: map['year'],
      truckNumber: map['truckNumber'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice': invoice,
      'date': date,
      'truckCount': truckCount,
      'cft': cft,
      'rate': rate,
      'price': price,
      'threeToFour': threeToFour,
      'oneToSix': oneToSix,
      'half': half,
      'fiveToTen': fiveToTen,
      'remarks': remarks,
      'port': port,
      'buyerName': buyerName,
      'buyerContact': buyerContact,
      'year': year,
      'truckNumber': truckNumber,
      'docID': docID
    };
  }
}
