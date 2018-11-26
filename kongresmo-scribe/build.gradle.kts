import org.springframework.boot.gradle.tasks.bundling.BootJar
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("io.spring.dependency-management").version("1.0.6.RELEASE")
    id("org.springframework.boot").version("2.0.1.RELEASE")
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-batch")
    // Use the Kotlin JDK 8 standard library
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}
repositories {
    mavenCentral()
}
