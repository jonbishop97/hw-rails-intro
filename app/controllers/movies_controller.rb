class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      print params
      @all_ratings = Movie.ratings
      @movies = Movie.all
      @title_sorted = false
      @release_date_sorted = false
      if params[:col] == "title"
        @title_sorted = true
      elsif params[:col] == "release_date"
        @release_date_sorted = true
      end
      
      if params.has_key?(:col)
        select_these = [""]
        params[:ratingselection].each do |key, value|
          if value
            select_these.append(key)
          end
        end
        @movies = Movie.select_by_ratings(select_these)
        @movies = @movies.order(params[:col])
      end
      
      @rating_selection = Hash.new
      if params.has_key?(:commit) and params[:commit] = "Refresh"
        if params.has_key?(:ratings)
          @movies = Movie.select_by_ratings(params[:ratings].keys)
          @all_ratings.each do |rating|
            @rating_selection[rating] = params[:ratings].has_key?(rating)
          end
        else
          @movies = Movie.select_by_ratings([""])
          @all_ratings.each do |rating|
            @rating_selection[rating] = false
          end
        end
      else
        @movies = Movie.select_by_ratings([@all_ratings])
        @all_ratings.each do |rating|
          @rating_selection[rating] = true
        end
      end
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end