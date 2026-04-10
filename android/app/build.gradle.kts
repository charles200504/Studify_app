plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.studify.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.studify.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

tasks.whenTaskAdded {
    val taskName = name
    if (taskName == "assembleDebug" || taskName == "assembleRelease") {
        doLast {
            val buildType = taskName.replace("assemble", "").toLowerCase()
            val srcApkDir = file("${project.layout.buildDirectory.get().asFile.absolutePath}/outputs/apk/$buildType")
            val destDir = file("${rootProject.projectDir.parentFile.absolutePath}/build/app/outputs/flutter-apk")
            if (srcApkDir.exists()) {
                destDir.mkdirs()
                srcApkDir.listFiles()?.forEach {
                    if (it.name.endsWith(".apk")) {
                        it.copyTo(File(destDir, "app-$buildType.apk"), overwrite = true)
                    }
                }
            }
            
            // Flutter also expects an APK directly in outputs/apk/... sometimes:
            val destDir2 = file("${rootProject.projectDir.parentFile.absolutePath}/build/app/outputs/apk/$buildType")
            if (srcApkDir.exists()) {
                destDir2.mkdirs()
                srcApkDir.listFiles()?.forEach {
                    if (it.name.endsWith(".apk")) {
                        it.copyTo(File(destDir2, "app-$buildType.apk"), overwrite = true)
                    }
                }
            }
        }
    }
}
