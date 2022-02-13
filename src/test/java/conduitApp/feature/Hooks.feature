Feature: Hooks

#  Before hooks
  Background: hooks
#    * def result = call read('classpath:helpers/dummy.feature')
#    * def username = result.username

#    after hooks
    * configure afterScenario = function(){ karate.call('classpath:helpers/dummy.feature') }
#    * configure afterScenario = function(){ karate.log('After scenario test') }
    * configure afterFeature =
    """
      function() {
        karate.log('After feature test');
      }
    """

  Scenario: First Scenario
#    * print username
    * print 'This is first scenario'

  Scenario: Second Scenario
#    * print username
    * print 'This is second scenario'