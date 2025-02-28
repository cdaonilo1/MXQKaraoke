# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Video Player
-keep class com.google.android.exoplayer2.** { *; }

# Just Audio
-keep class com.google.android.exoplayer2.** { *; }
-keep class com.ryanheise.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
