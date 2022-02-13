#@debug
Feature: Home Work
    Background: Preconditions
      * url apiUrl
      * def timeValidator = read('classpath:Helpers/time-validator.js')
      * def globalArticleReqBody = read('classpath:json/homeArticleRequest.json')
      * def dataGenerator = Java.type('Helpers.DataGenerator')
      * def randomComment = dataGenerator.getRandomArticleValues().body

    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
      Given params {limit:10, offset:0}
      And path 'articles'
      And request globalArticleReqBody
      When method GET
      Then status 200
        # Step 2: Get the favorites count and slug ID for the first article, save it to variables
      * def getFavoritesCount = response.articles[0].favoritesCount
      * def getSlugID = response.articles[0].slug
        # Step 3: Make POST request to increase favorites count for the first article
      Given path 'articles', getSlugID, 'favorite'
      When method POST
      Then status 200
      * def responseTitle = response.article.title
      * def responseGlobalFeed = globalArticleReqBody.article.title
        # Step 4: Verify response schema (jadi kita buat filejsonnya dulu n verify
      And match responseTitle == responseGlobalFeed
        # Step 5: Verify that favorites article incremented by 1
            #Example
            * def initialCount = 0
            * def response = {"favoritesCount": 1}
            * match response.favoritesCount == initialCount + 1

        # Step 6: Get all favorite articles
      Given params {favorited:admoons, limit:10, offset:0}
      And path 'articles'
      When method GET
      Then status 200
        # Step 7: Verify response schema
      And match responseTitle == responseGlobalFeed
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
      And match response.articles[0].slug == getSlugID

    Scenario: Comment articles
        # Step 1: Get articles of the global feed
      Given path 'articles'
      And request globalArticleReqBody
      When method GET
      Then status 200
        # Step 2: Get the slug ID for the first article, save it to variable
      * def getSlugsID = response.articles[0].slug
        # Step 3: Make a GET call to 'comments' end-point to get all comments
      Given path 'articles', getSlugsID, 'comments'
      When method GET
      Then status 200
        # Step 4: Verify response schema
      And match response.comments[0].body == "apa aja boleh"
        # Step 5: Get the count of the comments array length and save to variable
      * def commentsCount = response.comments.length

        # Step 6: Make a POST request to publish a new comment
      Given path 'articles', getSlugsID, 'comments'
      And request { comment : { body : "#(randomComment)" } }
      When method POST
      Then status 200
        # Step 7: Verify response schema that should contain posted comment text
      And match response ==
      """
        {
            "comment": {
                "id": '#number',
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "body": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                }
            }
        }
      """
    * def getCommentID = response.comment.id
        # Step 8: Get the list of all comments for this article one more time
      Given path 'articles', getSlugsID, 'comments'
      When method GET
      Then status 200
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
      * def commentIncreased = response.comments.length
      * match commentIncreased == commentsCount + 1
      * print 'jumlah comment terbaru: ' + commentIncreased

        # Step 10: Make a DELETE request to delete comment
      Given path 'articles', getSlugsID, 'comments', getCommentID
      When method DELETE
      Then status 204
        # Step 11: Get all comments again and verify number of comments decreased by 1
      Given path 'articles', getSlugsID, 'comments'
      When method GET
      Then status 200
      * def commentDecreased = response.comments.length
      * match commentDecreased == commentsCount
      * print 'jumlah comment sekarang: ' + commentDecreased