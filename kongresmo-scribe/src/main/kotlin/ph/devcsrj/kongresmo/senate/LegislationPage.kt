package ph.devcsrj.kongresmo.senate

import org.jsoup.nodes.Element
import pl.droidsonroids.jspoon.ElementConverter
import pl.droidsonroids.jspoon.annotation.Selector
import java.net.URI
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.regex.Pattern

class LegislationPage {

    @Selector(
        "#content",
        regex = "Filed on (.+) by",
        format = "MMMM dd, yyyy",
        converter = LocalDateElementConverter::class)
    lateinit var filingDate: LocalDate

    @Selector("#content > div.lis_doctitle > p")
    lateinit var title: String

    @Selector("#content > blockquote:nth-child(6)")
    lateinit var longTitle: String

    @Selector("#content > blockquote:nth-child(8)")
    lateinit var scope: String

    @Selector("#content > blockquote:nth-child(10)")
    lateinit var status: String

    @Selector("#content > blockquote:nth-child(13)", converter = SubjectElementConverter::class)
    lateinit var subjects: List<String>

    @Selector("#content > blockquote:nth-child(15)")
    lateinit var primaryCommitee: String

    @Selector("#lis_download > ul > li > a", converter = UriElementConverter::class)
    lateinit var documentUri: URI

    internal class LocalDateElementConverter : ElementConverter<LocalDate> {

        override fun convert(node: Element, selector: Selector): LocalDate {
            val pattern = Pattern.compile(selector.regex)
            val matcher = pattern.matcher(node.ownText())
            check(matcher.find()) {
                "Pattern '${selector.regex}' does not match: ${node.ownText()}"
            }
            val matched = matcher.group(1)
            return LocalDate.parse(matched, DateTimeFormatter.ofPattern(selector.format))
        }
    }

    internal class SubjectElementConverter : ElementConverter<List<String>> {

        override fun convert(node: Element, selector: Selector): List<String> {
            return node.html().split('\n')
                .map { it.substringAfter("<br>") }
        }

    }
}
