class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    
    if sort =="title"
      @table_header = 'hilite'
    elsif sort =="release_date"
      @release_date_header = 'hilite' 
    else 
      Movie.all
    end 
    
    @all_ratings = Movie.ratings
    
    if params.keys.include? "ratings"
      @ratings = params[:ratings].keys if params[:ratings].is_a? Hash
      @ratings = params[:ratings] if params[:ratings].is_a? Array 
    elsif session.keys.include? "ratings"
      @ratings = session[:ratings]
    else
      @ratings = @all_ratings
    end
    
    session[:ratings] = @ratings
    
    if !((params.keys.include? "sort") || (params.keys.include? "ratings"))
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
    @movies = Movie.where(:rating => @ratings).order(sort)
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
