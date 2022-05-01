class CustomerQueryParameters {
  final int pageNumber;
  final int pageSize;
  final String customerFlair;
  final bool banned;
  final String orderBy;

  CustomerQueryParameters({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.customerFlair,
    this.banned,
    this.orderBy,
  });
}
