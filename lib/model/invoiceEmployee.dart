
class InvoiceEmployee{
  final String name;
  final String post;
  final String salary;
  final String balance;
  final String due;
  final List<EmployeeItem> items;

  InvoiceEmployee(this.name, this.post, this.salary, this.balance, this.due,
      this.items);


}

class EmployeeItem{
  final String date;
  final String salaryAdvanced;
  final String salaryReloaded;
  final String remarks;

  EmployeeItem(
      this.date, this.salaryAdvanced, this.salaryReloaded, this.remarks);
}
