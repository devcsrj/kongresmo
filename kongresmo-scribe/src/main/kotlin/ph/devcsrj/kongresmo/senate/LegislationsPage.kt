package ph.devcsrj.kongresmo.senate

import pl.droidsonroids.jspoon.annotation.Selector
import java.net.URI

/**
 * Model representing the scrape-able data from [https://www.senate.gov.ph/lis/leg_sys.aspx?congress=17&type=bill&p=1]
 */
internal class LegislationsPage {

    @Selector("#form1 > div.alight > p")
    lateinit var entries: List<Entry>

    @Selector("#pnl_NavBottom > div > div > a:first-child", converter = UriElementConverter::class)
    lateinit var previousPage: URI

    @Selector("#pnl_NavBottom > div > div > a:last-child", converter = UriElementConverter::class)
    lateinit var nextPage: URI

    internal class Entry {

        /**
         * Represented in the form of [SBN-0000]
         */
        @Selector(value = "a > span", regex = "(.+)\\:")
        lateinit var number: String

        /**
         * The bill title
         */
        @Selector(value = "a > span", regex = "\\: (.+)")
        lateinit var title: String

        /**
         * The link for full details of the bill
         */
        @Selector(value = "a", converter = UriElementConverter::class)
        lateinit var uri: URI
    }
}
