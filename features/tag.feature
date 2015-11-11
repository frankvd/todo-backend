@tag
Feature: A user can add and remove tags to/from todo's
    Scenario: Add a tag
        Given "Bob" is logged in
        And "Bob" has a list named "groceries"
        And "Bob"'s list "groceries" has a todo named "milk"
        When "Bob" adds the tag "dairy" to "milk" in list "groceries"
        Then "Bob"'s todo "milk" in list "groceries" should have 1 tag "dairy"

    Scenario: Remove a tag
        Given "Bob" is logged in
        And "Bob" has a list named "groceries"
        And "Bob"'s list "groceries" has a todo named "milk"
        And "Bob"'s todo "milk" in list "groceries" has tag "dairy"
        And "Bob"'s todo "milk" in list "groceries" has tag "important"
        When "Bob" removes the tag "dairy" from "milk" in "groceries"
        Then "Bob"'s todo "milk" in list "groceries" should have 1 tag "important"
