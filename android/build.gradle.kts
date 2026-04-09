allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: File = file("C:/flutter_build_temp/${rootProject.name}")
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: File = File(newBuildDir, project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
