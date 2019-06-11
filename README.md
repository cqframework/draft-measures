# Draft Measures

This implementation guide provides draft measure content. Measures in this implementation guide are examples and works in progress and should not be considered final specifications or recommendations for clinical guidance. These examples will help guide and direct the process of finding conventions and usage patterns that meet the needs of the various stakeholders in the measure development community.

Commits to this repository will automatically trigger a new build of the IG, which will then be published to the following location:

[http://build.fhir.org/ig/cqframework/draft-measures](http://build.fhir.org/ig/cqframework/draft-measures)

Build log is available here:
[http://ig-build.fhir.org.s3-website-us-east-1.amazonaws.com/logs/cqframework/draft-measures](http://ig-build.fhir.org.s3-website-us-east-1.amazonaws.com/logs/cqframework/draft-measures)

Full debugging information is available here:
[http://build.fhir.org/ig/cqframework/draft-measures/debug.tgz](http://build.fhir.org/ig/cqframework/draft-measures/debug.tgz)

## Local Build

The HL7 IG Publisher is committed to this repository to make building as easy as possible. To build locally, clone the repository and issue the following command in the root:

    java -jar "org.hl7.fhir.igpublisher.jar" -ig ig.json

## Dependencies

Before the instructions in the above "Local Build" section will work, you
need to install several primary dependencies.

### Java

Go to [http://www.oracle.com/technetwork/java/javase/downloads/](
http://www.oracle.com/technetwork/java/javase/downloads/) and download the
latest (version 8 or higher) JDK for your platform, and install it.

### Ruby

Jekyll requires Ruby version 2.1 or greater.  Depending on your operating
system, you may already have Ruby bundled with it.  Otherwise, or if you
need a newer version, go to [https://www.ruby-lang.org/en/downloads/](
https://www.ruby-lang.org/en/downloads/) for directions.

### Jekyll

Go to [https://jekyllrb.com](https://jekyllrb.com) and follow the
instructions there, for example `gem install jekyll bundler`.  The end
result of this should be that the binary "jekyll" is now in your path.

