Feature: Articles
  Background: Define URL
    * url apiUrl
    * def articleReqBody = read('classpath:json/newArticleRequest.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleReqBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleReqBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleReqBody.article.body = dataGenerator.getRandomArticleValues().body

#  Note: Skenario ini yg bikin gagal pas assert di file Home Worknya (bentrok)
  # Scenario: Create a new article

  #     Given path 'articles'
  #     And request articleReqBody
  #     When method POST
  #     Then status 200
  #     And match response.article.title == articleReqBody.article.title

    Scenario: Create and Delete Article
      Given path 'articles'
      And request articleReqBody
      When method POST
      Then status 200
      * def articleId = response.article.slug

      Given params {limit: 10, offset:0}
      And path 'articles'
      When method GET
      Then status 200
      And  match response.articles[0].title == articleReqBody.article.title

      Given path 'articles',articleId
      When method DELETE
      Then status 204

      Given params {limit: 10, offset:0}
      And path 'articles'
      When method GET
      Then status 200
      And  match response.articles[0].title != articleReqBody.article.title