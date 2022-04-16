
class LC {
    String? date;
    String? truckCount;
    String? truckNumber;
    String? invoice;
    String? port;
    String? cft;
    String? rate;
    String? stockBalance;
    String? sellerName;
    String? sellerContact;
    String? paymentType;
    String? paymentInformation;
    String? purchaseBalance;
    String? lcOpenPrice;
    String? dutyCost;
    String? speedMoney;
    String? remarks;
    String? lcNumber;
    String? totalBalance;
    String? year;
    String? docID;


  LC({
      this.date,
      this.truckCount,
      this.truckNumber,
      this.invoice,
      this.port,
      this.cft,
      this.rate,
      this.stockBalance,
      this.sellerName,
      this.sellerContact,
      this.paymentType,
      this.paymentInformation,
      this.purchaseBalance,
      this.lcOpenPrice,
      this.dutyCost,
      this.speedMoney,
      this.remarks,
      this.lcNumber,
      this.totalBalance,
      this.year,
    this.docID
  });




  factory LC.fromMap(map){
    return LC(
      date: map['date'],
      truckCount: map['truckCount'],
      truckNumber: map['truckNumber'],
      invoice: map['invoice'],
      port: map['port'],
      cft: map['cft'],
      rate: map['rate'],
      stockBalance: map['stockBalance'],
      sellerName: map['sellerName'],
      sellerContact: map['sellerContact'],
      paymentType: map['paymentType'],
      paymentInformation: map['paymentInformation'],
      purchaseBalance: map['purchaseBalance'],
      lcOpenPrice: map['lcOpenPrice'],
      dutyCost: map['dutyCost'],
      speedMoney: map['speedMoney'],
      remarks: map['remarks'],
      lcNumber: map['lcNumber'],
      totalBalance: map['totalBalance'],
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
      'stockBalance': stockBalance,
      'sellerName': sellerName,
      'sellerContact': sellerContact,
      'paymentType': paymentType,
      'paymentInformation': paymentInformation,
      'purchaseBalance': purchaseBalance,
      'lcOpenPrice': lcOpenPrice,
      'dutyCost': dutyCost,
      'speedMoney': speedMoney,
      'remarks': remarks,
      'lcNumber': lcNumber,
      'totalBalance': totalBalance,
      'year': year,
      'docID': docID

    };
  }
}
