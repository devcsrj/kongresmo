import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:kongresmo_project/legislation/legislation.dart';
import 'package:quiver/check.dart';

abstract class LegislationApi {
  Stream<Legislation> fetchAll(int congress);
}

class SenateLegislationApi implements LegislationApi {
  Uri baseUri;
  http.Client httpClient;

  SenateLegislationApi(String baseUrl) {
    this.baseUri = Uri.parse(checkNotNull(baseUrl));
    this.httpClient = new http.Client();
  }

  @override
  Stream<Legislation> fetchAll(int congress) async* {
    var uri = baseUri
        .resolve("/lis/leg_sys.aspx?congress=$congress&type=bills&page=1");
    var htmlBody = await httpClient.get(uri).then((response) => response.body);
    var document = parse(htmlBody);
    var entries = document.querySelectorAll("#form1 > div.alight > p");
    for (var p in entries) {
      var span = p.querySelector("a > span");

      // SBN-2112: Exempting Medical Insurance Premiums From Income Tax and Fringe Benefit Tax
      if (!span.text.contains(':')) continue;
      var colon = span.text.indexOf(':');
      var number = span.text.substring(0, colon);
      var title = span.text.substring(colon + 1).trimLeft();
      yield new Legislation(number, title);
    }
  }
}
