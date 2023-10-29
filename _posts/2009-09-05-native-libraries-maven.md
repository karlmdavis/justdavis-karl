---
layout: post
title: "Native Libraries: VCS and Maven"
date: 2009-09-05
categories: coding maven
description: "Apache Maven is a wonderful tool for tracking, storing, and making use of compiled libraries, including native libraries (e.g. DLLs). Getting these libraries into Maven is simple."
---

Though I'm often guilty of doing it, it's a pretty bad idea to add anything already-compiled into your version control.  Chances are, it's a DLL or somesuch from a different project than you're committing it into.  If that's the case, by adding it to your project, you're deliberately mis-categorizing it.  If the DLL is actually from your project, then why aren't you just checking in the source code for it and building it as needed?  You also ought to consider whether you want to cope with the storage space requirements of binaries in your repository.  After a couple of years' worth of changes, this can get out of hand.

All that aside, I'd like to present some alternatives to doing this that I'm switching to in my code.  There are essentially two problems to be addressed: (1) Where should the native library be stored? and (2) How do you get the native library where you need it at build time?

## Storing Native Libraries as Maven Artifacts

Apache Maven is a wonderful tool for tracking, storing, and making use of compiled libraries.  Typically, these libraries are JARs but Maven can also handle native libraries.  Getting these libraries into Maven is as simple as:

```shell-session
$ mvn deploy:deploy-file \
    -DgeneratePom=true \
    -Dpackaging=dll \
    -Dclassifier=native-win-x86 \
    -DrepositoryId=yourRepoId \
    -Durl=file://C:\m2-repo
    -DgroupId=com.google.code.someprojectOrg \
    -DartifactId=someprojectId \
    -Dversion=1.2.3 \
    -DgeneratePom.description="The someprojectId library that makes excellent toast.  Please note that this project also requires a native library to be loaded."
    -Dfile=someprojectId-1.2.3.dll</code>
```

As long as you create and document some conventions on the classifier and packaging to use for each OS and architecture combination, you now have a standardized way of storing native libraries as Maven artifacts.

## Using Native Libraries via Maven

At some point in your project's build cycle, you'll want to be able to pull that native library out of Maven and into your build target.  The [maven-dependency-plugin](http://maven.apache.org/plugins/maven-dependency-plugin/) makes this easy.  Add the plugin to your POM's `<build/>` descriptor, set it to run during one of the build phases, and tell it what to get and where to put it.  The following sample POM configuration will copy the `someprojectId-1.2.3.dll` file from earlier into the project's `target/classes/native/` folder:

```xml
<project>
  [...]
  <build>
    <plugins>
      <plugin>
        <!-- Copy native libraries to target/classes/native/ -->
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-dependency-plugin</artifactId>
        <executions>
          <execution>
            <id>copy</id>
            <phase>generate-resources</phase>
            <goals>
              <goal>copy</goal>
            </goals>
            <configuration>
              <artifactItems>
                <artifactItem>
                  <groupId>com.google.code.someprojectOrg</groupId>
                  <artifactId>someprojectId</artifactId>
                  <version>1.2.3</version>
                  <type>dll</type>
                  <classifier>native-win-x86</classifier>
                  <overWrite>false</overWrite>
                  <outputDirectory>${project.build.outputDirectory}/native/windows/x86</outputDirectory>
                  <destFileName>someprojectId-1.2.3.dll</destFileName>
                </artifactItem>
              </artifactItems>
            </configuration>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
  [...]
</project>
```

Like most things with Maven, this is overly verbose, but simple enough to understand.  During the `generate-resources` build lifecycle phase, the maven-dependency-plugin will find the repository artifacts that match each specified `<artifactItem/>` and copy them to the specified `<outputDirectory/>` with the specified `<destFileName/>`.

Once the native artifacts have landed in your project's target folder, you can do whatever you want to with them.  If you control the code responsible for using the native libraries, they can be loaded via [System.load(String filename)](http://java.sun.com/javase/6/docs/api/java/lang/System.html#load(java.lang.String)).

I actually try to hide any code that uses native libraries behind an interface so that a mock implementation can be used for testing on all platforms.  That way I only have to use the native libraries for platform-specific tests and when it comes time to build my application's installers.

If you'd like to prevent the native libraries from being included in your project's package (e.g. the `.jar` file), the following POM snippet should do the trick:

```xml
<project>
  [...]
  <build>
    <plugins>
      <plugin>
        <!-- Ensure that the native libraries aren't packaged. -->
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <configuration>
          <excludes>
            <exclude>native/**</exclude>
          </excludes>
        </configuration>
      </plugin>
    </plugins>
  </build>
  [...]
</project>
```

Adding that exclusion will ensure that the native libraries don't end up in your repository a second time as part of the project they're being used in.
