package ph.devcsrj.kongresmo.senate

import okhttp3.HttpUrl
import okhttp3.OkHttpClient
import okhttp3.mockwebserver.MockResponse
import okhttp3.mockwebserver.MockWebServer
import okio.Buffer
import org.hamcrest.CoreMatchers.*
import org.hamcrest.MatcherAssert.assertThat
import org.hamcrest.Matchers.containsInAnyOrder
import pl.droidsonroids.retrofit2.JspoonConverterFactory
import retrofit2.Retrofit
import java.time.LocalDate
import java.time.Month
import java.util.concurrent.TimeUnit
import kotlin.test.Test

class SenateLegislationPageApiTest {

    @Test
    fun `can fetch legislations page`() {
        val server = mockWebServerWith("/bills-page1.htm")

        val api = getApi(server.url("/").toString())
        val response = api.fetch(17, "bills", 1).execute()
        assertThat(response.isSuccessful, `is`(equalTo(true)))

        val page = response.body()
        val entries = page!!.entries
        assertThat(entries[0].number, `is`(equalTo("SBN-2104")))
        assertThat(
            entries[0].title, `is`(
                equalTo("Automatic Reversal of the Excise Tax on Fuel Under R.A No.10963 (Train Law)")))
        assertThat(entries[0].uri, `is`(equalTo(server.url("/bill_res.aspx?congress=17&q=SBN-2104").uri())))

        val rr = server.takeRequest(50, TimeUnit.MILLISECONDS)
        assertThat(rr.method, `is`(equalTo("GET")))
        assertThat(rr.requestUrl.queryParameter("congress"), `is`(equalTo("17")))
        assertThat(rr.requestUrl.queryParameter("type"), `is`(equalTo("bills")))
        assertThat(rr.requestUrl.queryParameter("p"), `is`(equalTo("1")))
    }

    @Test
    fun `can fetch legislation page`() {
        val server = mockWebServerWith("/bills-SBN2104.htm")

        val api = getApi(server.url("/").toString())
        val response = api.fetchOne(17, "SBN-2104", "lbAll").execute()
        assertThat(response.isSuccessful, `is`(equalTo(true)))

        val page = response.body()!!
        assertThat(
            page.title,
            `is`(equalTo("AUTOMATIC REVERSAL OF THE EXCISE TAX ON FUEL UNDER R.A NO.10963 (TRAIN LAW)")))
        assertThat(page.longTitle, containsString("TAX REFORM FOR ACCELERATION AND INCLUSION (TRAIN)"))
        assertThat(page.filingDate, `is`(equalTo(LocalDate.of(2018, Month.NOVEMBER, 19))))
        assertThat(page.scope, `is`(equalTo("National")))
        assertThat(page.status, `is`(equalTo("Pending in the Committee (11/21/2018)")))
        assertThat(
            page.subjects, containsInAnyOrder(
                "Taxes (Excise Tax)",
                "Tax Reform for Acceleration and Inclusion Act (Train)",
                "National Internal Revenue Code (NIRC)",
                "Petroleum Products",
                "Fuel"
            ))
        assertThat(page.primaryCommitee, `is`(equalTo("Ways and Means")))
        assertThat(page.documentUri, `is`(server.url("/lisdata/2899425542!.pdf").uri()))


        val rr = server.takeRequest(50, TimeUnit.MILLISECONDS)
        assertThat(rr.method, `is`(equalTo("POST")))
        assertThat(rr.requestUrl.queryParameter("congress"), `is`(equalTo("17")))
        assertThat(rr.requestUrl.queryParameter("q"), `is`(equalTo("SBN-2104")))
    }

    private fun getApi(baseUrl: String): SenateLegislationPageApi {
        val retrofit = Retrofit.Builder()
            .baseUrl(HttpUrl.get(baseUrl))
            .client(OkHttpClient())
            .addConverterFactory(JspoonConverterFactory.create())
            .validateEagerly(true)
            .build()
        return retrofit.create(SenateLegislationPageApi::class.java)
    }

    private fun mockWebServerWith(resource: String): MockWebServer {
        val server = MockWebServer()
        server.start()
        val buffer = Buffer()
        buffer.readFrom(javaClass.getResourceAsStream(resource))
        server.enqueue(
            MockResponse()
                .setResponseCode(200)
                .setBody(buffer)
        )
        return server
    }
}
