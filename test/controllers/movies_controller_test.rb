require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_url
    assert_response :success
    assert_select "a#title_header[href*='sort_by=title']"
    assert_select "a#release_date_header[href*='sort_by=release_date']"
  end

  test "should sort movies by title" do
    get movies_url, params: { sort_by: "title" }
    assert_response :success

    assert_select "th.hilite a#title_header", text: "Movie Title"
    assert_operator response.body.index("Alpha"), :<, response.body.index("Zulu")
  end

  test "should sort movies by release date" do
    get movies_url, params: { sort_by: "release_date" }
    assert_response :success

    assert_select "th.hilite a#release_date_header", text: "Release Date"
    assert_operator response.body.index("Zulu"), :<, response.body.index("Alpha")
  end

  test "should keep sort in session and redirect to canonical url" do
    get movies_url, params: { sort_by: "title" }
    assert_response :success

    get movies_url
    assert_redirected_to movies_url(sort_by: "title")

    follow_redirect!
    assert_response :success
    assert_select "th.hilite a#title_header", text: "Movie Title"
  end

  test "should canonicalize legacy sort param" do
    get movies_url, params: { sort: "release_date" }
    assert_redirected_to movies_url(sort_by: "release_date")

    follow_redirect!
    assert_response :success
    assert_select "th.hilite a#release_date_header", text: "Release Date"
  end

  test "should filter movies by selected ratings" do
    get movies_url, params: { ratings: { "PG" => "1" } }
    assert_response :success

    assert_includes response.body, "Alpha"
    assert_not_includes response.body, "Zulu"
  end

  test "should keep ratings in session and redirect to canonical url" do
    get movies_url, params: { ratings: { "PG" => "1" } }
    assert_response :success

    get movies_url
    assert_redirected_to movies_url(ratings: { "PG" => "1" })

    follow_redirect!
    assert_response :success
    assert_includes response.body, "Alpha"
    assert_not_includes response.body, "Zulu"
  end

  test "should combine sorting and rating filter" do
    get movies_url, params: { sort_by: "title", ratings: { "PG" => "1", "R" => "1" } }
    assert_response :success

    assert_select "th.hilite a#title_header", text: "Movie Title"
    assert_operator response.body.index("Alpha"), :<, response.body.index("Zulu")
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
