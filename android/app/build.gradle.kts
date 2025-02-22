plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("flutter") // Aplica o plugin Flutter de forma declarativa
}

val localProperties = java.util.Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { load(it) }
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.karaoke.tvbox_karaoke" // Namespace do projeto
    compileSdk = 33

    defaultConfig {
        applicationId = "com.karaoke.tvbox_karaoke" // ID do aplicativo
        minSdk = 21
        targetSdk = 33
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    ndkVersion = "27.0.12077973" // Versão do NDK necessária

    buildTypes {
        release {
            // Configurações de release
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.22")
}

flutter {
    source = "../.."
}
