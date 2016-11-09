Feature: Words trainings
  In order to do words trainings
  As signed in Lingualeo user
  I want to request words for training and resolve trainings

  Scenario: Request a word for training
    Given I am successfully signed in into Lingualeo account
    When I send a message with trigger to start training
    Then I see a message back with a training word

  Scenario: Resolve training
    Given I am successfully signed in into Lingualeo account
    And I have started a training
    When I send a message with an answer
    Then I see a message back with a result
