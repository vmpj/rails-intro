class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    @checked_ratings = params[:ratings]
    logger.info "params[:ratings].has_key? #{@checked_ratings}"
    logger.info params[:ratings].has_key?('G') unless @checked_ratings.nil?
    # select all if none selected
    @checked_ratings ||= Hash[@all_ratings.collect { |v| [v, 1] }]
    logger.info "params[:ratings].has_key?2 #{@checked_ratings}"
    @titleClass='hilite' if params[:sortby] == 'title'
    @releaseDateClass='hilite' if params[:sortby] == 'release_date'


    @movies = Movie.order(params[:sortby])
    @movies = @movies.where(rating: @checked_ratings.map {|k, v| k}) unless @checked_ratings.nil?
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
