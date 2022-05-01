class UpdatableList<T> {
  List<T> list;

  List<T> update(
    T old,
    T updated,
  ) {
    int index = list.indexOf(list.firstWhere((element) => element == old));
    list.removeAt(index);
    return list;
  }
}
