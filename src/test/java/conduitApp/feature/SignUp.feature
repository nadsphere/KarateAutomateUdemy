Feature: Sign up new user
  Background: Define URL
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUname = dataGenerator.getRandomUsername()
    * url apiUrl

  Scenario: New User Sign up
    And path 'users'
    And request
    """
      {
          "user": {
              "email": #(randomEmail),
              "password": "admkarate123",
              "username": #(randomUname)
          }
      }
    """
    When method POST
    Then status 200
    And match response ==
    """
    {
        "user": {
            "email": #(randomEmail),
            "username": #(randomUname),
            "bio": null,
            "image": "#string",
            "token": "#string"
        }
    }
    """


  Scenario Outline: Validate Sign Up error messages
    Given path 'users'
    And request
    """
      {
          "user": {
              "email": "<email>",
              "password": "<password>",
              "username": "<username>"
          }
      }
    """
    When method POST
    Then status 422
    And match response == <errorResponse>

    Examples:
    | email           | password     | username               | errorResponse |
    | #(randomEmail)  | admkarate123 | hihihaaho              | {"errors":{"username":["has already been taken"]}} |
    | hihiho@mail.com | admkarate123 | #(randomUname)         | {"errors":{"email":["has already been taken"]}} |
    |                 | admkarate123 | #(randomUname)         | {"errors":{"email":["can't be blank"]}} |
    | #(randomEmail)  |              | #(randomUname)         | {"errors":{"password":["can't be blank"]}} |
    | #(randomEmail)  | admkarate123 |                        | {"errors":{"username":["can't be blank"]}} |


