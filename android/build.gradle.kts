plugins {
    id("com.android.library")
}

val agpVersion: String = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION
if (agpVersion.split(".")[0].toInt() < 9) {
    apply(plugin = "kotlin-android")
}

android {
    namespace = "de.coodoo.help_scout_beacon"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }

    dependencies {
        implementation("com.helpscout:beacon:7.0.2")
        testImplementation("org.jetbrains.kotlin:kotlin-test")
        testImplementation("org.mockito:mockito-core:5.22.0")
    }

    testOptions {
        unitTests.all {
            it.useJUnitPlatform()

            it.outputs.upToDateWhen { false }
            it.testLogging {
                events("passed", "skipped", "failed", "standardOut", "standardError")
                showStandardStreams = true
            }
        }
    }
}

// Keep Kotlin's target in step with compileOptions above; otherwise Kotlin defaults to the
// JDK's own version and Gradle 9 fails the build on the mismatch. Works under both KGP
// (AGP 8) and built-in Kotlin (AGP 9).
project.extensions.configure(org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension::class.java) {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}
