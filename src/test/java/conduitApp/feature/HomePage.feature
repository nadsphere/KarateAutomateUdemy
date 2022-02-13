Feature: Tests for the Home Page
  Background: Define URL
    Given url apiUrl

  Scenario: Get all tags
    Given path 'tags'
    When method GET
    Then status 200
    And match response.tags contains ['introduction', 'implementations']
    And match response.tags !contains 'web'
    And match response.tags contains any ['men', 'base', 'welcome']
    And match response.tags == "#array"
    And match each response.tags == "#string"

    Scenario: Get 10 articles from the Page
      * def timeValidator = read('classpath:helpers/time-validator.js')

      Given params {limit: 10, offset:0}
      And path 'articles'
      When method GET
      Then status 200
      And match each response.articles ==
      """
      {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "tagList": "#array",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": '#boolean'
            },
            "favoritesCount": '#number',
            "favorited": '#boolean'
        }
      """

  Scenario: Conditional Logic
    Given params {limit: 10, offset:0}
    And path 'articles'
    When method GET
    Then status 200
    * def favoritesCount = response.articles[0].favoritesCount
    * def article = response.articles[0]

#    * if (favoritesCount == 0) karate.call('classpath:Helpers/AddLikes.feature', article)

#    bisa pake cara lain
    * def result = favoritesCount == 0 ? karate.call('classpath:Helpers/AddLikes.feature', article).likesCount : favoritesCount

#    verify after add like
    Given params {limit: 10, offset:0}
    And path 'articles'
    When method GET
    Then status 200
#    And match response.articles[0].favoritesCount == 1
    And match response.articles[0].favoritesCount == result

  Scenario: Retry call
    * configure retry = {count: 10, interval: 5000}

    Given params {limit: 10, offset:0}
    And path 'articles'
    And retry until response.articles[0].favoritesCount == 1
    When method GET
    Then status 200

#  @debug
  Scenario: Sleep call
    * def sleep = function(pause){ java.lang.Thread.sleep(pause) }

    Given params {limit: 10, offset:0}
    And path 'articles'
    When method GET
    * eval sleep(5000)
    Then status 200
