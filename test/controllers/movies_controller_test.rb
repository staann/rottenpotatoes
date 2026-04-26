require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_url
    assert_response :success
  end

  test "should get new" do
    get new_movie_url
    assert_response :success
  end

  test "should create movie" do
    assert_difference("Movie.count") do
      post movies_url, params: { movie: { rating: @movie.rating, release_date: @movie.release_date, title: @movie.title } }
    end

    assert_redirected_to movies_url
    follow_redirect!
    assert_match "was successfully created", response.body
  end

  test "should show movie" do
    get movie_url(@movie)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_url(@movie)
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { rating: @movie.rating, release_date: @movie.release_date, title: @movie.title } }
    assert_redirected_to movie_url(@movie)
    follow_redirect!
    assert_match "was successfully updated", response.body
  end

  test "should destroy movie" do
    assert_difference("Movie.count", -1) do
      delete movie_url(@movie)
    end

    assert_redirected_to movies_url
    follow_redirect!
    assert_match "deleted", response.body
  end
end
