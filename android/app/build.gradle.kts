import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.plugin.compose")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseSigningProperties = Properties().apply {
    val propertiesFile = rootProject.file("key.properties")
    if (propertiesFile.exists()) propertiesFile.inputStream().use { load(it) }
}
fun releaseValue(property: String, environment: String): String? =
    System.getenv(environment)?.takeIf(String::isNotBlank)
        ?: releaseSigningProperties.getProperty(property)?.takeIf(String::isNotBlank)

val releaseStoreFile = releaseValue("storeFile", "MONY_RELEASE_STORE_FILE")
val releaseStorePassword = releaseValue("storePassword", "MONY_RELEASE_STORE_PASSWORD")
val releaseKeyAlias = releaseValue("keyAlias", "MONY_RELEASE_KEY_ALIAS")
val releaseKeyPassword = releaseValue("keyPassword", "MONY_RELEASE_KEY_PASSWORD")
val releaseSigningConfigured = listOf(
    releaseStoreFile,
    releaseStorePassword,
    releaseKeyAlias,
    releaseKeyPassword,
).all { !it.isNullOrBlank() }

android {
    namespace = "com.example.mony_multiplatform"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        compose = true
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mony_multiplatform"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        multiDexEnabled = true
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (releaseSigningConfigured) {
                storeFile = rootProject.file(releaseStoreFile!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

tasks.configureEach {
    if (
        name == "validateSigningRelease" ||
        name == "assembleRelease" ||
        name == "bundleRelease" ||
        name.startsWith("packageRelease")
    ) {
        doFirst {
            check(releaseSigningConfigured) {
                "Release signing is not configured. Set MONY_RELEASE_STORE_FILE, " +
                    "MONY_RELEASE_STORE_PASSWORD, MONY_RELEASE_KEY_ALIAS, and " +
                    "MONY_RELEASE_KEY_PASSWORD, or provide android/key.properties."
            }
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.glance:glance-appwidget:1.2.0")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
