
class InvoiceCompany{
  final String name;
  final String contact;
  final String address;
  final String due;
  final List<CompanyItem> items;

  InvoiceCompany(this.name, this.contact, this.address, this.due, this.items);
}

class CompanyItem{
  final String date;
 final String debit;
 final String credit;
 final String paymentType;
 final String paymentInfo;
  final String remarks;

  CompanyItem(this.date, this.debit, this.credit, this.paymentType,
      this.paymentInfo, this.remarks);
}
