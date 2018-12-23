import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:quiver/check.dart';

class HouseOfRepresentativesBill {
  int congress;
  String number;
  String title;

  HouseOfRepresentativesBill(this.congress, this.number, this.title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HouseOfRepresentativesBill &&
          runtimeType == other.runtimeType &&
          congress == other.congress &&
          number == other.number &&
          title == other.title;

  @override
  int get hashCode => congress.hashCode ^ number.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'HouseOfRepresentativesBill{congress: $congress, number: $number, title: $title}';
  }
}

abstract class HouseOfRepresentativesApi {
  Stream<HouseOfRepresentativesBill> fetchBills(int congress);
}

class HttpHouseOfRepresentativesApi implements HouseOfRepresentativesApi {
  Uri baseUri;
  http.Client httpClient;

  HttpHouseOfRepresentativesApi(String baseUrl) {
    this.baseUri = Uri.parse(checkNotNull(baseUrl));
    this.httpClient = new http.Client();
  }

  @override
  Stream<HouseOfRepresentativesBill> fetchBills(int congress) async* {
    var document = await _fetchDocumentByParam(congress);
    if (document == null) yield null;

    var form = document.querySelector("form[action='?v=billsresults']");
    if (form == null) yield null;

    // there's no easy way to fetch the entries, so we look for the
    // div.panel.panel-default
    while (!form.classes.containsAll(["panel", "panel-default"])) {
      form = form.nextElementSibling;
      if (form == null) yield null;
    }

    var panels = form.querySelectorAll("div[class='panel-heading']");
    for (var panel in panels) {
      var sibling = panel.nextElementSibling;
      if (!sibling.classes.contains('panel-body')) continue;
      var p = sibling.querySelector("p"); // just pick up the first

      String title = p.text;
      String number = panel.text;
      yield new HouseOfRepresentativesBill(congress, number, title);
    }
  }

  Future<Document> _fetchDocumentByParam(int congress) async {
    var uri = baseUri.resolveUri((Uri.parse("legisdocs/?v=bills")));
    return await httpClient.post(uri,
        body: {"v": "bills", "congress": "$congress"}).then((response) {
      return response.statusCode == 200 ? parse(response.body) : null;
    });
  }
}
