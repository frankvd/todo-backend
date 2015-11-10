@login
Feature: A user can login
    Scenario: Login
        Given the user "Bob" exists with the password "hunter2"
        When "Bob" logs in with the password "hunter2"
        Then the user "Bob" should be logged in
