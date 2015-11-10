@list
Feature: A user can manage lists
    Scenario: Create a list
        Given "Bob" is logged in
        When "Bob" adds a list named "groceries"
        Then "Bob" should have 1 list named "groceries"
