import 'package:html/dom.dart';
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
    Document document = await _fetchDocumentByParam(congress, 1);
    while (document != null) {
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
      var element =
          document.querySelector("#pnl_NavTop > div > div > a:last-child");
      if (element == null || element.text.trim() != "Next") break;
      var nextUri = Uri.parse(element.attributes["href"]);
      document = await _fetchDocumentByUri(nextUri);
    }
  }

  Future<Document> _fetchDocumentByUri(Uri relativeUri) async {
    var uri = baseUri.resolveUri(relativeUri);
    return await httpClient.get(uri).then((response) {
      return response.statusCode == 200 ? parse(response.body) : null;
    });
  }

  Future<Document> _fetchDocumentByParam(int congress, int page) async {
    return _fetchDocumentByUri(Uri.parse(
        "/lis/leg_sys.aspx?congress=$congress&type=bills&page=$page"));
  }
}
