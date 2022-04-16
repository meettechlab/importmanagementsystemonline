
class InvoiceStoneSale{
  final List<StoneSaleItem> items;

  InvoiceStoneSale(this.items);
}

class StoneSaleItem{
  final String date;
  final String truckCount;
  final String truckNumber;
  final String port;
  final String buyerName;
  final String buyerContact;
  final String cft;
  final String rate;
  final String total;
  final String paymentType;
  final String paymentInfo;
  final String remarks;

  StoneSaleItem(this.date, this.truckCount, this.truckNumber, this.port,
      this.buyerName, this.buyerContact, this.cft, this.rate, this.total,
      this.paymentType, this.paymentInfo, this.remarks);


}
