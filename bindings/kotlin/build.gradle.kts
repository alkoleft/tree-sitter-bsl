plugins {
    kotlin("jvm") version "1.9.0"
}

group = "org.treesitter"
version = "0.1.5"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.treesitter:jtreesitter:0.24.0")
}

kotlin {
    jvmToolchain(11)
}

sourceSets {
    main {
        kotlin {
            srcDirs(".")
        }
    }
}
