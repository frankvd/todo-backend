@list
Feature: A user can manage lists
    Scenario: Create a list
        Given "Bob" is logged in
        When "Bob" adds a list named "groceries"
        Then "Bob" should have 1 list named "groceries"

    Scenario: Remove a list
        Given "Bob" is logged in
        And "Bob" has a list named "groceries"
        And "Bob" has a list named "world domination"
        When "Bob" removes the list "world domination"
        Then "Bob" should have 1 list named "groceries"
