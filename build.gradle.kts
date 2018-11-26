import org.jetbrains.kotlin.gradle.plugin.KotlinPluginWrapper
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    apply(plugin = "kotlin")

    tasks.withType<KotlinCompile> {
        kotlinOptions.jvmTarget = "1.8"
        kotlinOptions.javaParameters = true
    }

    repositories {
        jcenter()
    }

    val compileKotlin: KotlinCompile by tasks
    compileKotlin.kotlinOptions {
        jvmTarget = "1.8"
    }
    val compileTestKotlin: KotlinCompile by tasks
    compileTestKotlin.kotlinOptions {
        jvmTarget = "1.8"
    }
}

group = "ph.devcsrj"

subprojects {
    version = "1.0-SNAPSHOT"
}

plugins {
    id("org.jetbrains.kotlin.jvm").version("1.2.71")
}

repositories {
    mavenCentral()
}
