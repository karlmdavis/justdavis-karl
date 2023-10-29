---
title: "Easy Peasy Maven Central"
layout: post
date: 2016/05/12
categories: coding
description: "I needed to push some tiny little open source projects of mine to Maven Central. I'd been avoiding this because I figured it'd be a huge hassle. Turns out, no: it's easy!"
---

Last week, I needed to push some tiny little open source projects of mine to Maven Central. I'd been avoiding this because I figured it'd be a huge hassle. Turns out, no: it's easy!

Pretty much everything you need to know is documented in detail here: [The Central Repository: OSSRH Guide](http://central.sonatype.org/pages/ossrh-guide.html). In short, though, the process goes like this:

1. File a ticket with the OSSRH project requesting a new repo.
    * The ticket I filed for this is [OSSRH-22242](https://issues.sonatype.org/browse/OSSRH-22242), which they resolved in **less than an hour**! Wow.
2. Update your POMs' `<distributionManagement />` section to point at your new OSSRH repos.
3. Ensure that your projects sign their artifacts, using the [maven-gpg-plugin](https://maven.apache.org/plugins/maven-gpg-plugin/usage.html).
    * With Ubuntu's GPG keyring integration, I only have to enter my key's password the first time in a login session.
4. Tweak your POMs a bit to comply with Central's very reasonable business rules.
    * If you mess this up, the repos will give you a very user-friendly error message explaining the problem.
    * My first try, I got an error, but just had to go back and add a `<developers />` section to my POM. No problem.
5. Optionally, you probably also want to start using [nexus-staging-maven-plugin](https://github.com/sonatype/nexus-maven-plugins/tree/master/staging/maven-plugin) (instead of [maven-deploy-plugin](https://maven.apache.org/plugins/maven-deploy-plugin/)). It's not required, but will make your life easier.
    * I tried to avoid this at first, myself. Decided to make the switch, though, because without this plugin I'd have to go in after each release and manually approve/promote the staged artifacts. Somewhat annoying, but happily the [nexus-staging-maven-plugin](https://github.com/sonatype/nexus-maven-plugins/tree/master/staging/maven-plugin)can do that automagically for you.

My projects are organized such that they all inherit from a single parent POM, so that's where I had to make all of the changes. Here's a trimmed-down version of what I ended up with:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <prerequisites>
    <maven>3.0</maven>
  </prerequisites>

  <groupId>com.justdavis.karl.jessentials</groupId>
  <artifactId>jessentials-parent</artifactId>
  <version>5.0.1-SNAPSHOT</version>
  <packaging>pom</packaging>

  <name>jessentials-parent</name>
  <description>
    A parent POM for this library collection, which helps to standardize 
    the plugins, libraries, and build settings used in the various modules.
  </description>
  <url>https://github.com/karlmdavis/jessentials</url>
  <organization>
    <name>Karl M. Davis</name>
  </organization>
  <licenses>
    <license>
      <name>Apache License 2.0</name>
      <url>http://spdx.org/licenses/Apache-2.0</url>
    </license>
  </licenses>

  <developers>
    <developer>
      <id>karlmdavis</id>
      <name>Karl M. Davis</name>
      <email>karl@justdavis.com</email>
      <url>https://justdavis.com/karl</url>
    </developer>
  </developers>

  <distributionManagement>
    <!-- Deploy these open source projects to the public OSSRH repositories, 
      per http://central.sonatype.org/pages/apache-maven.html. This helps ensure 
      that the releases land in the Maven Central repos. -->
    <snapshotRepository>
      <id>ossrh</id>
      <url>https://oss.sonatype.org/content/repositories/snapshots</url>
    </snapshotRepository>
    <repository>
      <id>ossrh</id>
      <url>https://oss.sonatype.org/service/local/staging/deploy/maven2/</url>
    </repository>
  </distributionManagement>

  <scm>
    <!-- URL format taken from http://www.sonatype.com/people/2009/09/maven-tips-and-tricks-using-github/ -->
    <connection>scm:git:git@github.com:karlmdavis/jessentials.git</connection>
    <developerConnection>scm:git:git@github.com:karlmdavis/jessentials.git</developerConnection>
    <url>https://github.com/karlmdavis/jessentials</url>
    <tag>HEAD</tag>
  </scm>

  <repositories>
    <repository>
      <id>ossrh-snapshots</id>
      <url>https://oss.sonatype.org/content/repositories/snapshots/</url>
      <releases>
        <enabled>false</enabled>
      </releases>
      <snapshots>
        <enabled>true</enabled>
      </snapshots>
    </repository>
  </repositories>

  <build>
    <pluginManagement>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-gpg-plugin</artifactId>
          <version>1.5</version>
        </plugin>
        <plugin>
          <groupId>org.sonatype.plugins</groupId>
          <artifactId>nexus-staging-maven-plugin</artifactId>
          <version>1.6.7</version>
          <configuration>
            <serverId>ossrh</serverId>
            <nexusUrl>https://oss.sonatype.org/</nexusUrl>
            <autoReleaseAfterClose>true</autoReleaseAfterClose>
          </configuration>
        </plugin>
      </plugins>
    </pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-gpg-plugin</artifactId>
        <executions>
          <execution>
            <!-- Ensure that all artifacts get signed prior to being deployed. 
              This is required for all artifacts heading to the Maven Central repo, but 
              is a good idea in general. -->
            <id>sign-artifacts</id>
            <phase>verify</phase>
            <goals>
              <goal>sign</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
      <plugin>
        <!-- Specifying this plugin here replaces the default deploy plugin in 
          the lifecycle: this plugin will be used to deploy artifacts. This is great 
          for interacting with OSSRH and deploying to Maven Central. However, it can 
          be disabled in descendant projects by setting 'extensions' to false. -->
        <groupId>org.sonatype.plugins</groupId>
        <artifactId>nexus-staging-maven-plugin</artifactId>
        <extensions>true</extensions>
      </plugin>
    </plugins>
  </build>

</project>
```

You can find the full POM here on Maven Central: [com.justdavis.karl.jessentials:jessentials-parent:5.0.0:pom](https://repo1.maven.org/maven2/com/justdavis/karl/jessentials/jessentials-parent/5.0.0/jessentials-parent-5.0.0.pom).

Many thanks to Sonatype and anyone else involved in the OSSRH repos for making this so simple!

