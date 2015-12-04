--- 
title: "Native Libraries: VCS and Maven"
kind: article
publish: true
created_at: 2009/09/05
tags: [coding, maven]
excerpt: "Apache Maven is a wonderful tool for tracking, storing, and making use of compiled libraries, including native libraries (e.g. DLLs). Getting these libraries into Maven is simple."
---

Though I'm often guilty of doing it, it's a pretty bad idea to add anything already-compiled into your version control.  Chances are, it's a DLL or somesuch from a different project than you're committing it into.  If that's the case, by adding it to your project, you're deliberately mis-categorizing it.  If the DLL is actually from your project, then why aren't you just checking in the source code for it and building it as needed?  You also ought to consider whether you want to cope with the storage space requirements of binaries in your repository.  After a couple of years' worth of changes, this can get out of hand.

All that aside, I'd like to present some alternatives to doing this that I'm switching to in my code.  There are essentially two problems to be addressed: (1) Where should the native library be stored? and (2) How do you get the native library where you need it at build time?

## Storing Native Libraries as Maven Artifacts

Apache Maven is a wonderful tool for tracking, storing, and making use of compiled libraries.  Typically, these libraries are JARs but Maven can also handle native libraries.  Getting these libraries into Maven is as simple as:

<pre class="CodeRay"><code class="language-bash">$ mvn deploy:deploy-file \
    -DgeneratePom=true \
    -Dpackaging=dll \
    -Dclassifier=native-win-x86 \
    -DrepositoryId=yourRepoId \
    -Durl=file://C:\m2-repo
    -DgroupId=com.google.code.someprojectOrg \
    -DartifactId=someprojectId \
    -Dversion=1.2.3 \
    -DgeneratePom.description="The someprojectId library that makes excellent toast.  Please note that this project also requires a native library to be loaded."
    -Dfile=someprojectId-1.2.3.dll</code></pre>

As long as you create and document some conventions on the classifier and packaging to use for each OS and architecture combination, you now have a standardized way of storing native libraries as Maven artifacts.

## Using Native Libraries via Maven

At some point in your project's build cycle, you'll want to be able to pull that native library out of Maven and into your build target.  The [maven-dependency-plugin](http://maven.apache.org/plugins/maven-dependency-plugin/) makes this easy.  Add the plugin to your POM's `&lt;build/&gt;` descriptor, set it to run during one of the build phases, and tell it what to get and where to put it.  The following sample POM configuration will copy the `someprojectId-1.2.3.dll` file from earlier into the project's `target/classes/native/` folder:

<pre class="CodeRay"><code class="language-xml">&lt;project&gt;
  [...]
  &lt;build&gt;
    &lt;plugins&gt;
      &lt;plugin&gt;
        &lt;!-- Copy native libraries to target/classes/native/ --&gt;
        &lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
        &lt;artifactId&gt;maven-dependency-plugin&lt;/artifactId&gt;
        &lt;executions&gt;
          &lt;execution&gt;
            &lt;id&gt;copy&lt;/id&gt;
            &lt;phase&gt;generate-resources&lt;/phase&gt;
            &lt;goals&gt;
              &lt;goal&gt;copy&lt;/goal&gt;
            &lt;/goals&gt;
            &lt;configuration&gt;
              &lt;artifactItems&gt;
                &lt;artifactItem&gt;
                  &lt;groupId&gt;com.google.code.someprojectOrg&lt;/groupId&gt;
                  &lt;artifactId&gt;someprojectId&lt;/artifactId&gt;
                  &lt;version&gt;1.2.3&lt;/version&gt;
                  &lt;type&gt;dll&lt;/type&gt;
                  &lt;classifier&gt;native-win-x86&lt;/classifier&gt;
                  &lt;overWrite&gt;false&lt;/overWrite&gt;
                  &lt;outputDirectory&gt;${project.build.outputDirectory}/native/windows/x86&lt;/outputDirectory&gt;
                  &lt;destFileName&gt;someprojectId-1.2.3.dll&lt;/destFileName&gt;
                &lt;/artifactItem&gt;
              &lt;/artifactItems&gt;
            &lt;/configuration&gt;
          &lt;/execution&gt;
        &lt;/executions&gt;
      &lt;/plugin&gt;
    &lt;/plugins&gt;
  &lt;/build&gt;
  [...]
&lt;/project&gt;</code></pre>

Like most things with Maven, this is overly verbose, but simple enough to understand.  During the `generate-resources` build lifecycle phase, the maven-dependency-plugin will find the repository artifacts that match each specified `&lt;artifactItem/&gt;` and copy them to the specified `&lt;outputDirectory/&gt;` with the specified `&lt;destFileName/&gt;`.

Once the native artifacts have landed in your project's target folder, you can do whatever you want to with them.  If you control the code responsible for using the native libraries, they can be loaded via [System.load(String filename)](http://java.sun.com/javase/6/docs/api/java/lang/System.html#load(java.lang.String)].

I actually try to hide any code that uses native libraries behind an interface so that a mock implementation can be used for testing on all platforms.  That way I only have to use the native libraries for platform-specific tests and when it comes time to build my application's installers.

If you'd like to prevent the native libraries from being included in your project's package (e.g. the `.jar` file), the following POM snippet should do the trick:

<pre class="CodeRay"><code class="language-xml">&lt;project&gt;
  [...]
  &lt;build&gt;
    &lt;plugins&gt;
      &lt;plugin&gt;
        &lt;!-- Ensure that the native libraries aren't packaged. --&gt;
        &lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
        &lt;artifactId&gt;maven-jar-plugin&lt;/artifactId&gt;
        &lt;configuration&gt;
          &lt;excludes&gt;
            &lt;exclude&gt;native/**&lt;/exclude&gt;
          &lt;/excludes&gt;
        &lt;/configuration&gt;
      &lt;/plugin&gt;
    &lt;/plugins&gt;
  &lt;/build&gt;
  [...]
&lt;/project&gt;</code></pre>

Adding that exclusion will ensure that the native libraries don't end up in your repository a second time as part of the project they're being used in.
