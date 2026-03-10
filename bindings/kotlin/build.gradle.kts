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
    testImplementation("junit:junit:4.13.2")
}

kotlin {
    jvmToolchain(22)
}

sourceSets {
    main {
        kotlin {
            srcDirs("src/main/kotlin")
        }
    }
    test {
        kotlin {
            srcDirs("src/test/kotlin")
        }
    }
}
