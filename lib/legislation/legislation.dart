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
  int get hashCode => number.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'Legislation{number: $number, title: $title}';
  }
}

class LegislationDetails {
  String number;
  String title;
  String longTitle;
  String scope;
  String status;
  List<String> subjects = [];
  List<String> committees = [];
  List<Log> logs = [];
}

class Log {
  DateTime date;
  String description;

  Log(this.date, this.description);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Log &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          description == other.description;

  @override
  int get hashCode => date.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'Log{date: $date, description: $description}';
  }
}

class Resource {
  String name;
  Uri link;

  Resource(this.name, this.link);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resource &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          link == other.link;

  @override
  int get hashCode => name.hashCode ^ link.hashCode;

  @override
  String toString() {
    return 'Document{name: $name, link: $link}';
  }
}
