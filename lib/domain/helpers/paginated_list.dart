import 'package:allbert_cms/domain/helpers/pagination_data.dart';

class PagedList<T> {
  List<T> items = [];
  PaginationData paginationData;

  PagedList(this.items, this.paginationData);

  PagedList.empty();
}
