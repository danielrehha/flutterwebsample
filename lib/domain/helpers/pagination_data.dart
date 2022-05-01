class PaginationData {
  final int totalCount;
  final int pageSize;
  final int currentPage;
  final int totalPages;
  final String previousPageLink;
  final String nextPageLink;

  PaginationData({
    this.totalCount,
    this.pageSize,
    this.currentPage,
    this.totalPages,
    this.previousPageLink,
    this.nextPageLink,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      totalCount: json["totalCount"],
      pageSize: json["pageSize"],
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
      previousPageLink: json["previousPageLink"] ?? null,
      nextPageLink: json["nextPageLink"] ?? null,
    );
  }
}
