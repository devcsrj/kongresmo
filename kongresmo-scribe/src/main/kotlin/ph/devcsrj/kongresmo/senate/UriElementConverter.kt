package ph.devcsrj.kongresmo.senate

import org.jsoup.nodes.Element
import pl.droidsonroids.jspoon.ElementConverter
import pl.droidsonroids.jspoon.annotation.Selector
import java.net.URI

internal class UriElementConverter : ElementConverter<URI> {

    override fun convert(node: Element, selector: Selector): URI {
        return URI.create(node.baseUri() + node.attr("href").substringAfter('/'))
    }

}
