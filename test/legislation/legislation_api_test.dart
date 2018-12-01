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
                "test/resources/senate.gov.ph/17th-congress-bills-page263.htm")
            .readAsStringSync());
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body = new File(
                "test/resources/senate.gov.ph/17th-congress-bills-page264.htm")
            .readAsStringSync());

      // when requesting with a page that exceeds the maximum pages, the
      // server returns the last page again, instead of a 404
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body = new File(
                "test/resources/senate.gov.ph/17th-congress-bills-page264.htm")
            .readAsStringSync());

      var api = new SenateLegislationApi(server.url);
      var legislation = api.fetchAll(17);

      expect(
          legislation,
          emitsInOrder([
            new Legislation("SBN-16", "The New Central Bank Act"),
            new Legislation("SBN-15", "Philippine Identification System Act"),
            new Legislation("SBN-14",
                "Amending the Revised Penal Code (Adjusting the Amount Involved on Which a Penalty Is Based)"),
            new Legislation(
                "SBN-13", "Salary Standardization Law of 2016 (Ssl 2016)"),
            new Legislation(
                "SBN-12", "Philippine Conditional Cash Transfer (CCT) Act"),
            new Legislation("SBN-11", "Transportation Crisis Act of 2016"),
            new Legislation("SBN-10", "National Internal Revenue Code of 1997"),
            new Legislation("SBN-9", "Philippine Mental Health Act of 2016"),
            // next page
            new Legislation("SBN-8",
                "Drug Rehabilitation Treatment for Philhealth Beneficiaries"),
            new Legislation("SBN-7", "Sim Card Registration Act of 2016"),
            new Legislation("SBN-6",
                "R.A.No. 53, to Include Print, Broadcast and Electronic Mass Media in the Exemption"),
            new Legislation("SBN-5", "Dangerous Drug Court (DDC)"),
            new Legislation("SBN-4", "Death Penalty Act of 2016"),
            new Legislation(
                "SBN-3", "Presidential Anti-Drug Authority (Prada) Act"),
            new Legislation("SBN-2", "14th Month Pay Law"),
            new Legislation("SBN-1", "Anti-Drug Penal Institution"),
            emitsDone,
          ]));
    });

    tearDown(() async {
      await server.shutdown();
    });
  });
}
