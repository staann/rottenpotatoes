Feature: Add existing movies by searching TMDb
  As a movie buff
  So that I can quickly add a movie to the RottenPotatoes database
  I want to search The Movie Database (TMDb) for a movie and add it

  Background: Start from the Search TMDb page
    Given I am on the RottenPotatoes home page
    Then I should see "Search TMDb for a movie"

  Scenario: Try to add nonexistent movie (sad path)
    When I fill in "Search Terms" with "asdfasdf"
    And I press "Search TMDb"
    Then I should be on the RottenPotatoes home page
    And I should see "'asdfasdf' was not found in TMDb."

  Scenario: View movie list after adding 2 movies (Imperative)
    When I fill in "Search Terms" with "Inception"
    And I press "Search TMDb"
    Then I should be on the RottenPotatoes home page
    When I fill in "Search Terms" with "The Matrix"
    And I press "Search TMDb"
    Then I should be on the RottenPotatoes home page
    And I should see "Inception"
    And I should see "The Matrix"