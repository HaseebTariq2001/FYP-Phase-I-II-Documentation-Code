plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.2" // ✅ Add version here!
}


android {
    namespace = "com.example.educare"  // ✅ Ensure it's all lowercase
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // ✅ Set required NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.educare"  // ✅ Ensure it's all lowercase
        minSdk = 23  // ✅ Firebase requires minSdkVersion 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")  // ✅ Ensure latest version
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}


