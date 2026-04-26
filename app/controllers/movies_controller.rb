class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @all_ratings = %w[G PG PG-13 R NC-17]
    requested_sort = params[:sort_by] || params[:sort]
    requested_ratings = params[:ratings]&.keys

    if sortable_column?(requested_sort)
      session[:sort_by] = requested_sort
    elsif requested_sort.present?
      session.delete(:sort_by)
    end

    if requested_ratings
      session[:ratings] = requested_ratings & @all_ratings
    end

    @sort_by = sortable_column?(requested_sort) ? requested_sort : session[:sort_by]
    @selected_ratings = requested_ratings || session[:ratings] || @all_ratings

    needs_sort_redirect =
      (params[:sort].present? && params[:sort_by].blank? && sortable_column?(requested_sort)) ||
      (params[:sort_by].blank? && params[:sort].blank? && sortable_column?(session[:sort_by]))

    needs_ratings_redirect = !params.key?(:ratings) && session[:ratings].present?

    if needs_sort_redirect || needs_ratings_redirect
      redirect_params = {}
      redirect_params[:sort_by] = @sort_by if sortable_column?(@sort_by)
      redirect_params[:ratings] = ratings_hash(@selected_ratings) if session[:ratings].present?
      redirect_to movies_path(redirect_params)
      return
    end

    @ratings_hash = session[:ratings].present? || params.key?(:ratings) ? ratings_hash(@selected_ratings) : nil
    @movies = Movie.where(rating: @selected_ratings)

    if sortable_column?(@sort_by)
      @movies = @movies.order(@sort_by)
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    @movie.update!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :release_date)
    end

    def sortable_column?(column_name)
      %w[title release_date].include?(column_name)
    end

    def ratings_hash(ratings)
      Array(ratings).index_with("1")
    end
end
