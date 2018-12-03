import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:kongresmo_project/legislation/legislation.dart';
import 'package:quiver/check.dart';

abstract class LegislationApi {
  Stream<Legislation> fetchAll(int congress);

  Future<LegislationDetails> fetchOne(int congress, String number);
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
        yield new Legislation(congress, number, title);
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

  @override
  Future<LegislationDetails> fetchOne(int congress, String number) async {
    var uri =
        baseUri.resolve("/lis/bill_res.aspx?congress=$congress&q=$number");
    // ASP.NET pages are a nightmare to crawl, as they add additional
    // client state details in the pages. So first we fetch the "landing page"
    var page = await httpClient.get(uri).then((response) {
      return response.statusCode == 200 ? parse(response.body) : null;
    });
    if (page == null) return null; // could not find the bill to begin with

    page = await httpClient.post(uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "__EVENTTARGET": "lbAll",
      "__EVENTARGUMENT": "",
      "__VIEWSTATE": page.querySelector("#__VIEWSTATE").attributes["value"],
      "__VIEWSTATEGENERATOR":
          page.querySelector("#__VIEWSTATEGENERATOR").attributes["value"],
      "__EVENTVALIDATION":
          page.querySelector("#__EVENTVALIDATION").attributes["value"],
    }).then((response) {
      return response.statusCode == 200 ? parse(response.body) : null;
    });

    // at this point, we now have the actual document that we want
    var details = new LegislationDetails();
    details.congress = congress;
    details.number = number;
    details.title = page.querySelector("#content > div.lis_doctitle > p").text;

    // All content are chucked into a <td id="#content">
    var content = page.querySelector("#content");
    for (Element elem in content.children) {
      // and each section is in the form of:
      //  <p>Section</p>
      //  <blockquote>Content</blockquote>
      if (elem.localName != "p") continue;
      var sibling = elem.nextElementSibling;
      if (sibling == null || sibling.localName != "blockquote") continue;

      switch (elem.text) {
        case "Long title":
          details.longTitle = sibling.text;
          break;
        case "Scope":
          details.scope = sibling.text;
          break;
        case "Legislative status":
          details.status = sibling.text;
          break;
        case "Subject(s)":
          details.subjects = sibling.innerHtml.split("<br>");
          break;
        case "Primary committee":
        case "Secondary committee":
          details.committees.addAll(sibling.innerHtml.split("<br>"));
          break;
        case "Legislative History":
          var rows = sibling.querySelectorAll("table > tbody > tr");
          if (rows == null) break;

          for (var row in rows) {
            if (row.children.length != 2) continue;

            // 2/27/2017
            var dateTokens = row.children[0].text.split("/");
            var date = new DateTime(int.parse(dateTokens[2]),
                int.parse(dateTokens[0]), int.parse(dateTokens[1]));
            var desc = row.children[1].text.trim();
            details.logs.add(new Log(date, desc));
          }

          break;
      }
    }

    return details;
  }
}
