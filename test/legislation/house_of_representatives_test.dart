import 'dart:io';

import 'package:kongresmo_project/legislation/house_of_representatives.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test_api/test_api.dart';

void main() {
  group('congress.gov.ph', () {
    MockWebServer server;
    setUp(() async {
      server = new MockWebServer();
      await server.start();
    });

    test('.fetchBills(17)', () {
      server.enqueueResponse(new MockResponse()
        ..httpCode = 200
        ..body =
            new File("test/resources/congress.gov.ph/17th-congress-bills.htm")
                .readAsStringSync()); // Yes, they have no pagination

      var api = new HttpHouseOfRepresentativesApi(server.url);
      var legislation = api.fetchBills(17);

      expect(
          legislation,
          emitsInOrder([
            new HouseOfRepresentativesBill(17, "HB00001",
                "AN ACT IMPOSING THE DEATH PENALTY ON CERTAIN HEINOUS CRIMES, REPEALING FOR THE PURPOSE REPUBLIC ACT NO. 9346, ENTITLED 'AN ACT PROHIBITING THE IMPOSITION OF DEATH PENALTY IN THE PHILIPPINES' AND AMENDING ACT NO. 3815, AS AMENDED, OTHERWISE KNOWN AS THE 'REVISED PENAL CODE,' AND OTHER SPECIAL PENAL LAWS"),
            new HouseOfRepresentativesBill(17, "HB00003",
                "AN ACT GRANTING PRESIDENT RODRIGO ROA DUTERTE, EMERGENCY POWERS TO ADDRESS THE MASSIVE TRAFFIC CONGESTION IN THE COUNTRY THAT HAS ASSUMED THE NATURE AND MAGNITUDE OF A NATIONAL EMERGENCY, DECLARING A NATIONAL POLICY IN CONNECTION THEREWITH AND AUTHORIZING HIM, FOR A LIMITED PERIOD AND SUBJECT TO RESTRICTIONS, TO IMPLEMENT RULES AND REGULATIONS NECESSARY AND PROPER TO CARRY OUT SUCH POWERS"),
            new HouseOfRepresentativesBill(17, "HB00004",
                "AN ACT CREATING CIRCUIT CRIMINAL COURTS GRANTING THEM EXCLUSIVE ORIGINAL JURISDICTION TO TRY AND DECIDE CERTAIN CRIMINAL CASES, AMENDING BATAS PAMBANSA BILANG 129, AS AMENDED, OTHERWISE KNOWN AS THE JUDICIARY REORGANIZATION ACT OF 1980, APPROPRIATING FUNDS THEREFOR AND FOR OTHER PURPOSES")
            // and so on
          ]));
    });

    tearDown(() async {
      await server.shutdown();
    });
  });
}
