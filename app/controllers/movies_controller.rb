class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def index
    @all_ratings = Movie.all_ratings
    sort_by = params[:sort_by] || session[:sort_by]
    @_ratings = params[:ratings]||session[:ratings]||{}
    @movies = Movie.where(rating: @_ratings.keys).order(sort_by)
    
    if @_ratings == {}
      @_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort_by] != session[:sort_by] or params[:ratings] != session[:ratings]
      session[:sort_by], session[:ratings] = sort_by, @_ratings
      flash.keep
      redirect_to movies_path :sort_by => sort_by, :ratings => @_ratings
    end
    
    @sort_column = sort_by
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
