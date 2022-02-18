Feature: Articles
Background: Define URL
  * url apiUrl
  * def articleReqBody = read('classpath:conduitApp/json/newArticleRequest.json')
  * def dataGenerator = Java.type('helpers.DataGenerator')
  * set articleReqBody.article.title = dataGenerator.getRandomArticleValues().title
  * set articleReqBody.article.description = dataGenerator.getRandomArticleValues().description
  * set articleReqBody.article.body = dataGenerator.getRandomArticleValues().body

  Scenario: Create and Delete Article
    Given path 'articles'
    And request articleReqBody
    When method POST
    Then status 200
    * def articleId = response.article.slug

    Given path 'articles',articleId
    When method DELETE
    Then status 204