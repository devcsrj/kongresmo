import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:kongresmo_project/legislation/bill.dart';
import 'package:quiver/check.dart';

/// Bill filed by a congressperson.
///
/// When filed with the Secretary General, the bill is filed as "H.B".
class HouseBill extends Bill {
  HouseBill(int congress, String number, String title)
      : super(congress, number, title);
}

/// The House of Representatives serves as the lower body of the Philippine
/// Congress.
///
/// It is composed by at most 250 congressperson. There are two types of
/// congressperson: the district and the sectoral representatives. The district
/// congressmen represent a particular geographical district of the country.
/// All provinces in the country are composed of at least one congressional
/// district.
abstract class HouseBillApi extends BillApi {
  Stream<HouseBill> fetchBills(int congress);
}

class HttpHouseBillApi implements HouseBillApi {
  Uri baseUri;
  http.Client httpClient;

  HttpHouseBillApi(String baseUrl) {
    this.baseUri = Uri.parse(checkNotNull(baseUrl));
    this.httpClient = new http.Client();
  }

  @override
  Stream<HouseBill> fetchBills(int congress) async* {
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
      yield new HouseBill(congress, number, title);
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
