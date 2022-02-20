# KarateAutomateUdemy

UI Angular: https://github.com/gothinkster/angular-realworld-example-app

How to run?
1) Run with tags
mvn clean test "-Dkarate.options=--tags @debug"*
* note: you can customize any tags if you want

2) Run all features, you can comment ".tags("@debug")" or remove (optional)
mvn clean test

Update: 
To run gatling project: mvn clean test-compile gatling:test or mvn test
