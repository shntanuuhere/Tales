plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
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
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.hereco.tales"
        minSdk = 24
        targetSdk = 34
        versionCode = 2
        versionName = "1.0.2"
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
        // Use debug signing config for now
        // We'll create a proper release signing config later
    }

    buildTypes {
        release {
            // Temporarily disable minification for debugging
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("debug") // Use debug signing for now
        }
    }

    buildFeatures {
        viewBinding = true
    }

    lint {
        abortOnError = false
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")

    // Use a newer Firebase BOM version that's compatible with Kotlin 2.0.0
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-analytics-ktx")

    // Play Core dependencies for dynamic feature modules and in-app updates
    implementation("com.google.android.play:core:1.10.3")
    implementation("com.google.android.play:core-ktx:1.8.1")

    // Add explicit Kotlin stdlib dependency
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.0.0")
}

flutter {
    source = "../.."
}
