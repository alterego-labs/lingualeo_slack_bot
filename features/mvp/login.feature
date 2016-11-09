Feature: Sign in via a slack bot API into Lingualeo account
  In order to get an access to the Lingualeo DB with ennglish words
  As a slack user
  I want to sign in into Lingualeo account
  
  Scenario: Successfully sign in
    Given I provide a valid credentials
    When I send a message
    Then I see a message back with greetings

  Scenario: Failure sign in
    Given I provide an invalid credentials
    When I send a message
    Then I see a message back with error
