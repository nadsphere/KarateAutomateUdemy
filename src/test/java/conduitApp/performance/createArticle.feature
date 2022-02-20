Feature: Articles
Background: Define URL
  * url apiUrl
  * def articleReqBody = read('classpath:conduitApp/json/newArticleRequest.json')
  * def dataGenerator = Java.type('helpers.DataGenerator')
  * set articleReqBody.article.title = dataGenerator.getRandomArticleValues().title
  * set articleReqBody.article.description = dataGenerator.getRandomArticleValues().description
  * set articleReqBody.article.body = dataGenerator.getRandomArticleValues().body

  * def sleep = function(ms){java.lang.Thread.sleep(ms)}
  * def pause = karate.get('__gatling.pause', sleep)

  Scenario: Create and Delete Article
    Given path 'articles'
    And request articleReqBody
    When method POST
    Then status 200
    * def articleId = response.article.slug

    * pause(5000)
    # * karate.pause(5000)

    Given path 'articles',articleId
    When method DELETE
    Then status 204