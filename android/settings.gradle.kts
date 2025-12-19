pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        if (!localPropertiesFile.exists()) {
            throw java.io.FileNotFoundException("local.properties not found in ${settingsDir}")
        }
        localPropertiesFile.inputStream().use { properties.load(it) }

        // prefer flutter.sdk, fallback to sdk.dir (created by Android tools)
        val sdkProp = properties.getProperty("flutter.sdk") ?: properties.getProperty("sdk.dir")
        require(sdkProp != null) { "flutter.sdk or sdk.dir not set in local.properties" }
        sdkProp
    }

    // Normalize Windows backslashes and use File to avoid illegal filename syntax
    val flutterSdkDir = java.io.File(flutterSdkPath.replace('\\', '/'))
    val flutterGradleDir = java.io.File(flutterSdkDir, "packages/flutter_tools/gradle")
    if (!flutterGradleDir.exists()) {
        throw java.io.FileNotFoundException("Flutter gradle directory not found: ${flutterGradleDir.absolutePath}")
    }
    includeBuild(flutterGradleDir)

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
