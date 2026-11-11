allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// flutter_ringtone_player 4.0.0+4, its latest release, compiles against
// android-33, while the AndroidX libraries the app resolves need 34 or later,
// so the release build fails its AAR metadata check. Raise only that
// plugin's compileSdk to the app's; its minSdk and behaviour stay as they are.
subprojects {
    if (name == "flutter_ringtone_player") {
        afterEvaluate {
            extensions.configure<com.android.build.gradle.LibraryExtension> {
                compileSdk = project(":app").extensions
                    .getByType<com.android.build.api.dsl.ApplicationExtension>()
                    .compileSdk
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
