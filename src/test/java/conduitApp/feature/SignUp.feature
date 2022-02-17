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

  @debug
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
    | email               | password     | username               | errorResponse |
    | #(randomEmail)      | user1234     | userkarate             | {"errors":{"username":["has already been taken"]}} |
    | userkarate@mail.com | user1234     | #(randomUname)         | {"errors":{"email":["has already been taken"]}} |
    |                     | user1234     | #(randomUname)         | {"errors":{"email":["can't be blank"]}} |
    | #(randomEmail)      |              | #(randomUname)         | {"errors":{"password":["can't be blank"]}} |
    | #(randomEmail)      | user1234     |                        | {"errors":{"username":["can't be blank"]}} |

#    case yg ternyata expectednya 200
#    | userkarate          | user1234     | #(randomUname)         | {"errors":{"email":["is invalid"]}} |
#    | #(randomEmail)      | user1234     | userkarate12345678901  | {"errors":{"username":["is too long (maximum is 20 character)"]}} |
#    | #(randomEmail)      | user         | #(randomUname)         | {"errors":{"password":["is too short (minimum is 8 character)"]}} |



