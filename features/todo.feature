@todo
Feature: A user can add and remove todo's
    Scenario: Add a todo
        Given "Bob" is logged in
        And "Bob" has a list named "groceries"
        When "Bob" adds "milk" to "groceries"
        Then "Bob"'s list "groceries" should have 1 todo named "milk"

    Scenario: Remove a todo
        Given "Bob" is logged in
        And "Bob" has a list named "groceries"
        And "Bob"'s list "groceries" has a todo named "milk"
        And "Bob"'s list "groceries" has a todo named "bread"
        When "Bob" removes "milk" from "groceries"
        Then "Bob"'s list "groceries" should have 1 todo named "bread"
