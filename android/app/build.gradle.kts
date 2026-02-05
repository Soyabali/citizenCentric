plugins {
    id("com.android.application")
    //id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

dependencies {
    // Firebase BOM (keeps all firebase versions compatible)
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))
    // Firebase Messaging WITHOUT the old firebase-iid
    // Keep Firebase Analytics optional
    implementation("com.google.firebase:firebase-analytics")
}

android {
    namespace = "com.synergy.noidapark"
    compileSdk = 36  // ✔ safe level that all ML-Kit libs support

    defaultConfig {
        applicationId = "com.synergy.noidapark"
        minSdk = 24
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")

            // ✔ Only 1 clean setting
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

/**
 * ❗ REMOVE ALL force() rules
 * MLKit-Flutter packages include correct version mappings.
 */
configurations.all {
    exclude(group = "com.google.firebase", module = "firebase-iid")
}

flutter {
    source = "../.."
}
