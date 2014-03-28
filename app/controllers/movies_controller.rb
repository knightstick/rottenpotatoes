# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
      @all_ratings = Movie.all_ratings
      if ! params[:sort].nil?
        sort = params[:sort]
      elsif ! session[:sort].nil?
        sort = session[:sort]
      else
        sort = nil
      end

      if ! params[:ratings].nil?
        session[:ratings] = params[:ratings]
        ratings = params[:ratings].map {|k,v| k if v}.compact
      elsif ! session[:ratings].nil?
        flash.keep
        redirect_to movies_path(ratings: session[:ratings])
      else
       ratings = @all_ratings
      end

      @ratings = ratings
      @order = sort
      @movies = Movie.find(:all, :order => @order, 
                  :conditions => ["rating IN (?)", @ratings])
      session[:sort] = @order
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
