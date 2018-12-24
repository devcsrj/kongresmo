/// A Bill is a proposed legislation under consideration. It goes under a series
/// of steps where it is discussed, debated, and voted upon.
class Bill {
  int congress;
  String number;
  String title;

  Bill(this.congress, this.number, this.title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bill &&
          runtimeType == other.runtimeType &&
          congress == other.congress &&
          number == other.number &&
          title == other.title;

  @override
  int get hashCode => congress.hashCode ^ number.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'Bill{congress: $congress, number: $number, title: $title}';
  }
}

/// Interface for fetching [Bill]s.
///
/// The Philippine legislature is a bicameral congress, consisting of two houses:
/// the Senate and the House of the Representatives. Bills go through a thorough
/// process in each house, and then submitted to the other house for concurrence.
abstract class BillApi {
  Stream<Bill> fetchBills(int congress);
}
