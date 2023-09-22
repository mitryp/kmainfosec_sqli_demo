/// A range of integers between [from] (inclusive) and [to] (exclusive).
typedef Range = (int from, int to);

extension RangeMethods on Range {
  String of(String str) => str.substring($1, $2);

  int get length => $2 - $1 - 1;
}
