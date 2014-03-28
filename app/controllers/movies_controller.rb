# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
      @order = params[:sort]
      @all_ratings = Movie.all_ratings
      if ! params[:ratings].nil?
        @ratings = params[:ratings].map {|k,v| k if v}.compact unless 
                                                           params[:ratings].nil?
      else
        @ratings = @all_ratings
      end
      @movies = Movie.find(:all, :order => params[:sort], 
                  :conditions => ["rating IN (?)", @ratings])
      
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
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
