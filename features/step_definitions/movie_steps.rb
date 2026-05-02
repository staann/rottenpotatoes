require 'rspec/expectations'
World(RSpec::Matchers)

Given(/^I am on the RottenPotatoes home page$/) do
  visit movies_path
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field, with: value
end

When(/^I press "(.*?)"$/) do |button|
  click_button button
end

Then(/^I should be on the RottenPotatoes home page$/) do
  expect(current_path).to eq(movies_path)
end

Given(/^the following movies exist:$/) do |table|
  table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

When(/^I go to the edit page for "(.*?)"$/) do |movie_title|
  movie = Movie.find_by(title: movie_title)
  visit edit_movie_path(movie)
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |movie_title, director|
  movie = Movie.find_by(title: movie_title)
  expect(movie.director).to eq(director)
end

Given(/^I am on the details page for "(.*?)"$/) do |movie_title|
  movie = Movie.find_by(title: movie_title)
  visit movie_path(movie)
end

When(/^I follow "(.*?)"$/) do |link|
  click_link link
end

Then(/^I should be on the Similar Movies page for "(.*?)"$/) do |movie_title|
  movie = Movie.find_by(title: movie_title)
  expect(current_path).to eq(search_directors_movie_path(movie))
end

Then(/^I should not see "(.*?)"$/) do |text|
  expect(page).not_to have_content(text)
end

Then(/^I should be on the home page$/) do
  expect(current_path).to eq(movies_path)
end