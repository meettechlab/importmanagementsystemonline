
class InvoiceStonePurchase{
  final String lcNumber;
  final String sellerName;
  final String sellerContact;
  final String rate;
  final String lcOpenPrice;
  final String dutyCost;
  final String speedMoney;
  final List<StonePurchaseItem> items;

  InvoiceStonePurchase(this.lcNumber, this.sellerName, this.sellerContact,
      this.rate, this.lcOpenPrice, this.dutyCost, this.speedMoney, this.items);
}

class StonePurchaseItem{
  final String date;
  final String truckCount;
  final String truckNumber;
  final String port;
  final String cft;
  final String remarks;

  StonePurchaseItem(
      this.date, this.truckCount, this.truckNumber, this.port, this.cft,this.remarks);
}
