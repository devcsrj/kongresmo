import 'dart:io';

import 'package:kongresmo_project/legislation/senate.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test_api/test_api.dart';

void main() {
  group('senate.gov.ph', () {
    MockWebServer server;
    setUp(() async {
      server = new MockWebServer();
      await server.start();
    });

    test('.fetchBills(17)', () {
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

      var api = new HttpSenateBillApi(server.url);
      var legislation = api.fetchBills(17);

      expect(
          legislation,
          emitsInOrder([
            new SenateBill(17, "SBN-16", "The New Central Bank Act"),
            new SenateBill(
                17, "SBN-15", "Philippine Identification System Act"),
            new SenateBill(17, "SBN-14",
                "Amending the Revised Penal Code (Adjusting the Amount Involved on Which a Penalty Is Based)"),
            new SenateBill(
                17, "SBN-13", "Salary Standardization Law of 2016 (Ssl 2016)"),
            new SenateBill(
                17, "SBN-12", "Philippine Conditional Cash Transfer (CCT) Act"),
            new SenateBill(17, "SBN-11", "Transportation Crisis Act of 2016"),
            new SenateBill(
                17, "SBN-10", "National Internal Revenue Code of 1997"),
            new SenateBill(
                17, "SBN-9", "Philippine Mental Health Act of 2016"),
            // next page
            new SenateBill(17, "SBN-8",
                "Drug Rehabilitation Treatment for Philhealth Beneficiaries"),
            new SenateBill(17, "SBN-7", "Sim Card Registration Act of 2016"),
            new SenateBill(17, "SBN-6",
                "R.A.No. 53, to Include Print, Broadcast and Electronic Mass Media in the Exemption"),
            new SenateBill(17, "SBN-5", "Dangerous Drug Court (DDC)"),
            new SenateBill(17, "SBN-4", "Death Penalty Act of 2016"),
            new SenateBill(
                17, "SBN-3", "Presidential Anti-Drug Authority (Prada) Act"),
            new SenateBill(17, "SBN-2", "14th Month Pay Law"),
            new SenateBill(17, "SBN-1", "Anti-Drug Penal Institution"),
            emitsDone,
          ]));
    });

    test('.fetchBill(17, SBN-1354)', () async {
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body = new File(
                "test/resources/senate.gov.ph/17th-congress-bills-sbn1354.htm")
            .readAsStringSync());
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body = new File(
                "test/resources/senate.gov.ph/17th-congress-bills-sbn1354-all.htm")
            .readAsStringSync());

      var api = new HttpSenateBillApi(server.url);
      var legislation = await api.fetchBill(17, "SBN-1354");

      expect(legislation.congress, 17);
      expect(legislation.number, "SBN-1354");
      expect(legislation.title, "MENTAL HEALTH ACT OF 2017");
      expect(legislation.longTitle,
          startsWith("AN ACT ESTABLISHING A NATIONAL MENTAL HEALTH "));
      expect(legislation.scope, "National");
      expect(legislation.status,
          "Approved by the President of the Philippines (6/20/2018)");
      expect(legislation.subjects, ["Mental Health"]);
      expect(legislation.committees,
          ["Health and Demography", "Local Government", "Finance"]);
      expect(legislation.logs.length, 28);

      // assert request
      var rr = server.takeRequest();
      expect(rr.method, "GET");
      expect(rr.uri.pathSegments, ["lis", "bill_res.aspx"]);
      expect(rr.uri.queryParameters["congress"], "17");
      expect(rr.uri.queryParameters["q"], "SBN-1354");

      rr = server.takeRequest();
      expect(rr.method, "POST");
      expect(rr.uri.pathSegments, ["lis", "bill_res.aspx"]);
      expect(rr.uri.queryParameters["congress"], "17");
      expect(rr.uri.queryParameters["q"], "SBN-1354");
      expect(rr.headers['content-type'],
          contains("application/x-www-form-urlencoded"));
      expect(
          rr.body,
          "__EVENTTARGET=lbAll&__EVENTARGUMENT=&__VIEWSTATE=%2FwEP"
          "DwUJNjIyOTUxNjI5D2QWAgIBD2QWAgIBD2QWBgIBDw8WBh4IQ3NzQ2xhc3MFE2xpc19"
          "ib2xkX2xpbmtidXR0b24eB0VuYWJsZWRoHgRfIVNCAgJkZAINDw8WBB4EVGV4dAUMUm"
          "VwdWJsaWMgQWN0HgdWaXNpYmxlaGRkAg8PDxYCHwRoZGRkxhmc7v44F58V%2BiYdxpn"
          "AjIv4vUw%3D&__VIEWSTATEGENERATOR=AB8B2AD5&__EVENTVALIDATION=%2FwEWB"
          "QLCqsfmAgLJ%2FIvGBwLH35XtCwL4k9H6DAKLqrzFDYkzj4DRfMavPDDhSGjIauHBRm"
          "f%2F");
    });

    test('.fetchSenators(17) - most recent', () async {
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body = new File("test/resources/senate.gov.ph/senator-list.htm")
            .readAsStringSync());

      var api = new HttpSenateBillApi(server.url);
      var senators = await api.fetchSenators(17);

      expect(senators, [
        new Senator('Vicente C. Sotto III'),
        new Senator('Aquilino \'Koko\' Pimentel III'),
        new Senator('Ralph G. Recto'),
        new Senator('Juan Miguel "Migz" F. Zubiri'),
        new Senator('Franklin M. Drilon'),
        new Senator('Juan Edgardo "Sonny" M. Angara'),
        new Senator('Paolo Benigno "Bam" Aquino IV'),
        new Senator('Maria Lourdes Nancy S. Binay'),
        new Senator('Alan Peter Compañero S. Cayetano'),
        new Senator('Leila de Lima'),
        new Senator('Joseph Victor "JV" G. Ejercito'),
        new Senator('Francis "Chiz" G. Escudero'),
        new Senator('Sherwin "Win" T. Gatchalian'),
        new Senator('Richard J. Gordon'),
        new Senator('Gregorio B. Honasan II'),
        new Senator('Risa Hontiveros'),
        new Senator('Panfilo "Ping" M. Lacson'),
        new Senator('Loren B. Legarda'),
        new Senator('Emmanuel "Manny" D. Pacquiao'),
        new Senator('Francis "Kiko" Pangilinan'),
        new Senator('Grace L. Poe'),
        new Senator('Antonio "Sonny" F. Trillanes IV'),
        new Senator('Emmanuel Joel J. Villanueva'),
        new Senator('Cynthia A. Villar')
      ]);
      expect(senators.length, 24);

      var rr = server.takeRequest();
      expect(rr.method, "GET");
      expect(rr.uri.pathSegments, ["senators", "senlist.asp"]);
    });

    test('.fetchSenators(16) - non recent', () async {
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body = new File("test/resources/senate.gov.ph/senator-list.htm")
            .readAsStringSync());

      var api = new HttpSenateBillApi(server.url);
      var senators = await api.fetchSenators(16);

      expect(senators, [
        new Senator('Franklin M. Drilon'),
        new Senator('Ralph G. Recto'),
        new Senator('Alan Peter Compañero S. Cayetano'),
        new Senator('Juan Ponce Enrile'),
        new Senator('Juan Edgardo "Sonny" M. Angara'),
        new Senator('Paolo Benigno "Bam" Aquino IV'),
        new Senator('Maria Lourdes Nancy S. Binay'),
        new Senator('Pia S. Cayetano'),
        new Senator('Miriam Defensor Santiago'),
        new Senator('Joseph Victor G. Ejercito'),
        new Senator('Francis "Chiz" G. Escudero'),
        new Senator('Jinggoy Ejercito Estrada'),
        new Senator('Teofisto "TG" Guingona III'),
        new Senator('Gregorio B. Honasan II'),
        new Senator('Manuel "Lito" M. Lapid'),
        new Senator('Loren B. Legarda'),
        new Senator('Ferdinand "Bongbong" R. Marcos, Jr.'),
        new Senator('Sergio R. Osmeña III'),
        new Senator('Aquilino \'Koko\' Pimentel III'),
        new Senator('Grace L. Poe'),
        new Senator('Ramon "Bong" Revilla, Jr.'),
        new Senator('Vicente C. Sotto III'),
        new Senator('Antonio "Sonny" F. Trillanes IV'),
        new Senator('Cynthia A. Villar'),
      ]);
      expect(senators.length, 24);
    });

    tearDown(() async {
      await server.shutdown();
    });
  });
}
