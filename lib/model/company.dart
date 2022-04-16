
class Company {
    String? id;
    String? name;
    String? contact;
    String? address;
    String? credit;
    String? debit;
    String? remarks;
    String? invoice;
    String? paymentTypes;
    String? paymentInfo;
    String? date;
    String? year;
    String? docID;


  Company({
    this.id,
    this.name,
    this.contact,
    this.address,
    this.credit,
    this.debit,
    this.remarks,
    this.invoice,
    this.paymentTypes,
    this.paymentInfo,
    this.date,
    this.year,
    this.docID
  });


  factory Company.fromMap(map){
    return Company(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      address: map['address'],
      credit: map['credit'],
      debit: map['debit'],
      remarks: map['remarks'],
      invoice: map['invoice'],
      paymentTypes: map['paymentTypes'],
      paymentInfo: map['paymentInfo'],
      date: map['date'],
      year: map['year'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'address': address,
      'credit': credit,
      'debit': debit,
      'remarks': remarks,
      'invoice': invoice,
      'paymentTypes': paymentTypes,
      'paymentInfo': paymentInfo,
      'date': date,
      'year': year,
      'docID': docID
    };
  }
}
