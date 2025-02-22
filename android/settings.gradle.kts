pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

include(":app")

val localPropertiesFile = file("local.properties")
val properties = java.util.Properties()

assert(localPropertiesFile.exists())
localPropertiesFile.inputStream().use { properties.load(it) }

val flutterSdkPath = properties.getProperty("flutter.sdk")
assert(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
apply(from = "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle")
