plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("org.sonarqube") version "6.0.1.5171"
}

import org.gradle.api.JavaVersion

kotlin {
    jvmToolchain(17)

    // Configure Kotlin compiler options
    sourceSets.all {
        languageSettings {
            // Allow using Kotlin 2.0 features
            apiVersion = "2.0"
            languageVersion = "2.0"
        }
    }
}

val kotlinVersion = "2.0.0"

buildscript {
    repositories {
        mavenCentral()
        google()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.0.0")
    }
}

android {
    namespace = "com.hereco.tales"
    compileSdk = 34
    ndkVersion = "26.1.10909125"

    defaultConfig {
        applicationId = "com.hereco.tales"
        minSdk = 24
        targetSdk = 34
        versionCode = 4
        versionName = "1.1.0"
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
        // Add compatibility flag for Kotlin 2.0
        freeCompilerArgs = listOf("-Xskip-metadata-version-check")
    }

    signingConfigs {
        create("release") {
            // These values will be replaced during CI/CD or manual signing
            storeFile = file("keystore.jks")
            storePassword = "password"
            keyAlias = "key"
            keyPassword = "password"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            applicationIdSuffix = ".debug"
            isDebuggable = true
        }
    }

    buildFeatures {
        viewBinding = true
    }

    lint {
        abortOnError = false
        disable += "Instantiatable" // Disable lint check that causes issues with Flutter plugins
    }

    // This is needed for some Flutter plugins that don't specify a namespace
    packagingOptions {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")

    // Use the latest Firebase BOM version
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-crashlytics-ktx")

    // Play Core dependencies for dynamic feature modules and in-app updates
    implementation("com.google.android.play:app-update:2.1.0")
    implementation("com.google.android.play:app-update-ktx:2.1.0")

    // Add explicit Kotlin stdlib dependency
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.0.0")

    // Add explicit androidx.core dependency to help with plugin compatibility
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
}

sonar {
  properties {
    property("sonar.projectKey", "shntanuuhere_Tales")
    property("sonar.organization", "shntanuuhere")
    property("sonar.host.url", "https://sonarcloud.io")
  }
}

flutter {
    source = "../.."
}
