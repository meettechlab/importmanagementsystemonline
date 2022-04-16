
class InvoiceCoal{
  final String stock;
  final String amount;
  final String lc;
  final List<CoalItem> items;

  InvoiceCoal(this.stock, this.amount, this.lc,this.items);
}

class CoalItem{
  final String date;
  final String truckCount;
  final String truckNumber;
  final String port;
  final String buyerName;
  final String ton;
  final String rate;
  final String total;
  final String paymentType;
  final String paymentInfo;
  final String remarks;

  CoalItem(this.date, this.truckCount, this.truckNumber, this.port,
      this.buyerName,  this.ton, this.rate, this.total,
      this.paymentType, this.paymentInfo, this.remarks);


}
