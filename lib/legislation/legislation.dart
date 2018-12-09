class Legislation {
  int congress;
  String number;
  String title;

  Legislation(this.congress, this.number, this.title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Legislation &&
          runtimeType == other.runtimeType &&
          congress == other.congress &&
          number == other.number &&
          title == other.title;

  @override
  int get hashCode => congress.hashCode ^ number.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'Legislation{congress: $congress, number: $number, title: $title}';
  }
}

class LegislationDetails {
  int congress;
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

class Senator {
  String name;

  Senator(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Senator &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Senator{name: $name}';
  }
}
