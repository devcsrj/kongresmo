
class Legislation {
  String number;
  String title;

  Legislation(this.number, this.title);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Legislation &&
              runtimeType == other.runtimeType &&
              number == other.number &&
              title == other.title;

  @override
  int get hashCode =>
      number.hashCode ^
      title.hashCode;

  @override
  String toString() {
    return 'Legislation{number: $number, title: $title}';
  }
}
