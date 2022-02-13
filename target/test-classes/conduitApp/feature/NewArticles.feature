Feature: Articles
  Background: Define URL
    * url apiUrl
    * def articleReqBody = read('classpath:json/newArticleRequest.json')
#    Call method yg DataGenerator.java
    * def dataGenerator = Java.type('Helpers.DataGenerator')
    * set articleReqBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleReqBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleReqBody.article.body = dataGenerator.getRandomArticleValues().body
  @parallel=false
  Scenario: Create a new article

      Given path 'articles'
      And request articleReqBody
      When method POST
      Then status 200
      And match response.article.title == articleReqBody.article.title

#  Note: Skenarion ini yg bikin gagal pas assert di file Home Worknya (bentrok)
  @parallel=false
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

#  note:
#  udah bisa create tapi stuck di assertion judulyang udah di-create (ga bia nge get)
#  jadinya stopper ga bisa running hapus article
#  klo mau articlenya dihapus harus di-comment dulu yg assert pertama baru bisa jalanin