Foo.
# Developer Notes

Enrollio requires Grails 1.2.

Some steps need to be taken before running Enrollio:

# Configuration

You will want to change some of the things in your Config.groovy before running
Enrollio.

grails.serverURL is currently hard-coded to "http://enrollio.org".  You will want
to change this.

# Compile App

> grails compile

# Compile Error

If you receive the following error when running grails compile:

  Error executing script TestApp: : java.lang.NoClassDefFoundError: 
  Lcom/gargoylesoftware/htmlunit/html/HTMLParser$HtmlUnitDOMBuilder;

Then, just run the compile again!

## You might want to increase permgen size on your JVM

This will avoid permgen out-of-memory errors when running the tests.

Put the following in your .bashrc or .profile

    export JAVA_OPTS=-XX:MaxPermSize=128m

## Create the src/java and src/groovy directories

CD to the directory where you downloaded Enrollio, and run the following commands:
  
    $ mkdir -p src/groovy
    $ mkdir -p src/java

## Run the tests / fix DOMBuilder Error

We try to write a comprehensive set of tests for Enrollio.
All tests should pass before you use Enrollio.

CD to the directory where you downloaded Enrollio, and run the following commands:

    $ grails test-app

If you receive the following error:

  Error executing script TestApp: : java.lang.NoClassDefFoundError: 
  Lcom/gargoylesoftware/htmlunit/html/HTMLParser$HtmlUnitDOMBuilder;

You merely need to run the tests again:

    $ grails test-app

## Log file locations

If you don't run tomcat as root, there could be a problem with lucene (the search engine)
wanting to store its indexes in /usr/share/tomcat6, or some other directory that the 
tomcat user doesn't have write access to.

I just ran the following hack:

  sudo mkdir /usr/share/tomcat6/.grails 
  sudo chmod 777 /usr/share/tomcat6/.grails

# Building War File

Run the tests and the application itself before building the .war file.

Also, see the jasperreports-2.0.5 kludge below.

# Upgrading Enrollio

If you've downloaded Enrollio before the Grails 1.2 upgrade, you should
only need to install Grails 1.2 to run enrollio.

# Functional Tests fail if run w/unit & integration

As of 2010/04/02, you need to run functional tests separately from integration and
unit tests.  If you just run grails test-app, there is a failure in the UserFunctionalTests:

  No signature of method: java.util.Collections$UnmodifiableRandomAccessList.click() is 
  applicable for argument types: () values: []

Any solutions to this problem are welcome.
