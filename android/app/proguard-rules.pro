# --- ML Kit Core ---
-keep class com.google.mlkit.** { *; }
-keep interface com.google.mlkit.** { *; }

# --- Google Play Services internal MLKit ---
-keep class com.google.android.gms.internal.mlkit_* { *; }

# --- ML Kit Text Recognizers (Chinese, Japanese, Korean, Devanagari) ---
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }

# --- Vision Models ---
-keep class com.google.mlkit.vision.** { *; }

# --- Language + Translation ---
-keep class com.google.mlkit.nl.** { *; }

# --- Smart Reply ---
-keep class com.google.mlkit.nl.smartreply.** { *; }

# --- LinkFirebase (required for model download) ---
-keep class com.google.mlkit.linkfirebase.** { *; }
-dontwarn com.google.mlkit.linkfirebase.**

# Avoid warnings
-dontwarn com.google.firebase.iid.**
-dontwarn com.google.mlkit.**
