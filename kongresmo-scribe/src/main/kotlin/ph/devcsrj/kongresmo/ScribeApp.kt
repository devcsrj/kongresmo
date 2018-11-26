package ph.devcsrj.kongresmo

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

@SpringBootApplication
open class ScribeApp

fun main(args: Array<String>) {
    SpringApplication.run(ScribeApp::class.java, *args)
}
