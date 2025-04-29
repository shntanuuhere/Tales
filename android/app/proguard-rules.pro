# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Firebase rules
-keep class com.google.firebase.** { *; }
-keep class com.firebase.** { *; }
-keep class org.apache.** { *; }
-keepnames class com.fasterxml.jackson.** { *; }
-keepnames class javax.servlet.** { *; }
-keepnames class org.ietf.jgss.** { *; }
-dontwarn org.apache.**
-dontwarn org.w3c.dom.**

# Keep your model classes
-keep class com.hereco.tales.models.** { *; }

# Gson specific rules
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# OkHttp rules
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**

# General Android rules
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class androidx.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep the R class and its fields
-keep class **.R
-keep class **.R$* {
    <fields>;
}

# Keep Play Core classes
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep Kotlin metadata
-keepattributes Signature,RuntimeVisibleAnnotations,AnnotationDefault,*Annotation*,SourceFile,LineNumberTable,Exceptions,InnerClasses,EnclosingMethod

# Keep Kotlin serialization
-dontnote kotlinx.serialization.AnnotationsKt

# Keep Kotlin coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}

# Keep Kotlin 2.0 specific classes
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-keep class org.jetbrains.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**
-dontwarn org.jetbrains.**

# Keep Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Google Play Core
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

# Wallpaper plugins
-keep class com.example.imagegallerysaver.** { *; }
-keep class com.mulgundkar.wallpaper_manager_plus.** { *; }
-dontwarn com.example.imagegallerysaver.**
-dontwarn com.mulgundkar.wallpaper_manager_plus.**
