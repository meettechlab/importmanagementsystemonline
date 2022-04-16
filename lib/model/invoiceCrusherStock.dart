
class InvoiceCrusherStock{
  final List<CrusherStockItem> items;

  InvoiceCrusherStock(this.items);
}

class CrusherStockItem{
  final String date;
  final String truckCount;
  final String port;
  final String buyerName;
  final String buyerContact;
  final String cft;
  final String rate;
  final String totalPrice;
  final String threeToFour;
  final String sixteen;
  final String half;
  final String fiveToTen;
  final String totalWeight;
  final String extra;
  final String remarks;

  CrusherStockItem(this.date, this.truckCount, this.port,
      this.buyerName, this.buyerContact, this.cft, this.rate, this.totalPrice, this.threeToFour,this.sixteen,this.half,this.fiveToTen,this.totalWeight, this.extra,
 this.remarks);


}
