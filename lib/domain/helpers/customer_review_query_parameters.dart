class CustomerReviewQueryParameters {
  final int pageNumber;
  final int pageSize;
  final String employeeId;
  final String rating;
  final DateTime from;
  final DateTime until;
  final String orderBy;

  CustomerReviewQueryParameters({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.employeeId,
    this.rating,
    this.from,
    this.until,
    this.orderBy,
  });
}
