import 'package:allbert_cms/domain/helpers/pagination_data.dart';

class PresentationHelper {
  int getCurrentPageLimit(PaginationData paginationData) {
    if (paginationData.currentPage * paginationData.pageSize >
        paginationData.totalCount) {
      if (paginationData.pageSize > paginationData.totalCount) {
        return paginationData.totalCount;
      }

      return paginationData.totalCount;
    }
    return paginationData.currentPage * paginationData.pageSize;
  }
}