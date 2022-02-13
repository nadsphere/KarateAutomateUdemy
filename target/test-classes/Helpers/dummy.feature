Feature: Dummy
  Scenario: Dummy
    * def dataGenerator = Java.type('Helpers.DataGenerator')
    * def username = dataGenerator.getRandomUsername()
    * print username


