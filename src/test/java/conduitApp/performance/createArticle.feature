Feature: Articles
Background: Define URL
  * url apiUrl
  * def articleReqBody = read('classpath:conduitApp/json/newArticleRequest.json')
  * def dataGenerator = Java.type('helpers.DataGenerator')
  * set articleReqBody.article.title = dataGenerator.getRandomArticleValues().title
  * set articleReqBody.article.description = dataGenerator.getRandomArticleValues().description
  * set articleReqBody.article.body = dataGenerator.getRandomArticleValues().body
  
  # for case 41 read file csv yg udah dibuat utk akses nilai ke feature file
  # * set articleReqBody.article.title = __gatling.Title
  # * set articleReqBody.article.description = __gatling.Description

  * def sleep = function(ms){java.lang.Thread.sleep(ms)}
  * def pause = karate.get('__gatling.pause', sleep)

  Scenario: Create and Delete Article
    * configure headers = {"Authorization": #('Token ' + __gatling.token)}
    Given path 'articles'
    And request articleReqBody
    And header karate-name = 'Create & Delete Article'
    # bisa dicustomize
    # And header karate-name = 'Title requested: ' + dataGenerator.getRandomArticleValues().title
    When method POST
    Then status 200
    * def articleId = response.article.slug

    # * karate.pause(5000)
    * pause(5000)

    Given path 'articles',articleId
    When method DELETE
    Then status 204