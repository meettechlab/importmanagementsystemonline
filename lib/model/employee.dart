
class Employee {
    String? date;
    String? name;
    String? post;
    String? salary;
    String? salaryAdvanced;
    String? balance;
    String? due;
    String? remarks;
    String? invoice;
    String? contact;
    String? address;
    String? year;
    String? docID;


  Employee({
      this.date,
      this.name,
      this.post,
      this.salary,
      this.salaryAdvanced,
      this.balance,
      this.due,
      this.remarks,
      this.invoice,
      this.contact,
      this.address,
      this.year,
    this.docID
  });



  factory Employee.fromMap(map){
    return Employee(
      date: map['date'],
        name: map['name'],
      post: map['post'],
      salary: map['salary'],
      salaryAdvanced: map['salaryAdvanced'],
        balance: map['balance'],
      due: map['due'],
      remarks: map['remarks'],
      invoice: map['invoice'],
      contact: map['contact'],
      address: map['address'],
      year: map['year'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'name' : name,
      'post': post,
      'salary': salary,
      'salaryAdvanced': salaryAdvanced,
      'balance': balance,
      'due': due,
      'remarks': remarks,
      'invoice': invoice,
      'contact': contact,
      'address': address,
      'year': year,
      'docID': docID
    };
  }
}
