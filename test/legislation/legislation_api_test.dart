import 'dart:io';

import 'package:kongresmo_project/legislation/legislation.dart';
import 'package:kongresmo_project/legislation/legislation_api.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test_api/test_api.dart';

void main() {
  group('senate.gov.ph', () {
    MockWebServer server;
    setUp(() async {
      server = new MockWebServer();
      await server.start();
    });
    
    test('.fetchAll(17)', () {
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body = new File(
                "test/resources/senate.gov.ph/17th-congress-bills-page1.htm")
            .readAsStringSync());

      var api = new SenateLegislationApi(server.url);
      var legislation = api.fetchAll(17);

      expect(
          legislation,
          emitsInOrder([
            new Legislation("SBN-2112",
                "Exempting Medical Insurance Premiums From Income Tax and Fringe Benefit Tax"),
            new Legislation("SBN-2111", "Public Solicitation Act"),
            new Legislation("SBN-2110", "Long Term Care Fire Safety Act"),
            new Legislation("SBN-2109", "Philippine Online Infringement Act"),
            new Legislation("SBN-2108", "Poverty Reducation Through Social Entrepreneurship (Present) Act"),
            new Legislation("SBN-2107", "Reducing the Value-Added Tax Rate to 10% Effective January 1, 2019"),
            new Legislation("SBN-2106", "Cisfa Amendments of 2018"),
            new Legislation("SBN-2105", "Regulation and Organization of Islamic Banks"),
            emitsDone,
          ]));
    });

    tearDown(() async {
      await server.shutdown();
    });
  });
}
