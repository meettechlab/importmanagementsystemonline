
class InvoiceDaily{
  final String totalCost;
  final String type;
  final List<DailyItem> items;

  InvoiceDaily(this.totalCost, this.type, this.items);
}

class DailyItem{
  final String date;
  final String transport;
  final String unload;
  final String depo;
  final String koipot;
  final String stone;
  final String dissel;
  final String griss;
  final String mobil;
  final String extra;
  final String total;
  final String remarks;

  DailyItem(
      this.date,
      this.transport,
      this.unload,
      this.depo,
      this.koipot,
      this.stone,
      this.dissel,
      this.griss,
      this.mobil,
      this.extra,
      this.total,
      this.remarks);
}
