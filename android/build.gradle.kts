import org.gradle.api.plugins.JavaPluginExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import com.android.build.gradle.BaseExtension

plugins {
    kotlin("android") version "2.0.0" apply false
    id("com.android.application") version "8.2.1" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
      id("com.google.firebase.firebase-perf") version "1.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: Customize the build directory location
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    project.layout.buildDirectory.set(newBuildDir.dir(project.name))

    afterEvaluate {
        project.plugins.withId("com.android.application") {
            extensions.configure<BaseExtension>("android") {
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
        project.plugins.withId("org.jetbrains.kotlin.android") {
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
                kotlinOptions {
                    jvmTarget = "17"
                }
            }
        }
        tasks.withType<JavaCompile> {
            sourceCompatibility = JavaVersion.VERSION_17.toString()
            targetCompatibility = JavaVersion.VERSION_17.toString()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
