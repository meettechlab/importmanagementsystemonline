
class InvoiceCrusherSale{
  final String threeToFour;
  final String sixteen;
  final String half;
  final String fiveToTen;
  final String totalStock;
  final String totalSale;
  final List<CrusherSaleItem> items;

  InvoiceCrusherSale(this.threeToFour,this.sixteen,this.half,this.fiveToTen,this.totalStock, this.totalSale,this.items);
}

class CrusherSaleItem{
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
  final String remarks;

  CrusherSaleItem(this.date, this.truckCount, this.port,
      this.buyerName, this.buyerContact, this.cft, this.rate, this.totalPrice, this.threeToFour,this.sixteen,this.half,this.fiveToTen,
      this.remarks);
}
