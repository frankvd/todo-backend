Feature: A user can create an account
    Scenario: Valid registration
        When "Bob" registers an account with password "hunter2"
        Then the user "Bob" should exist
    Scenario: Registration with an existing username
        Given user "Bob" exists
        When "Bob" registers an account with password "hunter2"
        Then the registration should fail
