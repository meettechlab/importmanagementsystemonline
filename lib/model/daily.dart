
class Daily {
    String? invoice;
    String? date;
    String? transport;
    String? unload;
    String? depoRent;
    String? koipot;
    String? stoneCrafting;
    String? disselCost;
    String? grissCost;
    String? mobilCost;
    String? totalBalance;
    String? extra;
    String? remarks;
    String? year;
    String? docID;


  Daily({
    this.invoice,
    this.date,
    this.transport,
    this.unload,
    this.depoRent,
    this.koipot,
    this.stoneCrafting,
    this.disselCost,
    this.grissCost,
    this.mobilCost,
    this.totalBalance,
    this.extra,
    this.remarks,
    this.year,
    this.docID
  });



  factory Daily.fromMap(map){
    return Daily(
      invoice: map['invoice'],
      date: map['date'],
      transport: map['transport'],
      unload: map['unload'],
      depoRent: map['depoRent'],
      koipot: map['koipot'],
      stoneCrafting: map['stoneCrafting'],
      disselCost: map['disselCost'],
      grissCost: map['grissCost'],
      mobilCost: map['mobilCost'],
      totalBalance: map['totalBalance'],
      extra: map['extra'],
      remarks: map['remarks'],
      year: map['year'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice': invoice,
      'date': date,
      'transport': transport,
      'unload': unload,
      'depoRent': depoRent,
      'koipot': koipot,
      'stoneCrafting': stoneCrafting,
      'disselCost': disselCost,
      'grissCost': grissCost,
      'mobilCost': mobilCost,
      'totalBalance': totalBalance,
      'extra': extra,
      'remarks': remarks,
      'year': year,
      'docID': docID
    };
  }
}
