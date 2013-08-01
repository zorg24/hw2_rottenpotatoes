class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    # redirect if needed
    if (!params.key?(:sort) && session.key?(:sort)) || (!params.key?(:rating) && session.key?(:rating))
      flash.keep
      redirect_to :action => 'index', :sort => params.key?(:sort) ? params[:sort] : session[:sort], :rating => params.key?(:rating) ? params[:rating] : session[:rating]
    end

    # update session
    session[:sort] = params.key?(:sort) ? params[:sort] : session[:sort]
    session[:rating] = params.key?(:rating) ? params[:rating] : session[:rating]

    if !session.key? :rating
      rat = Movie.ratings
      session[:rating] = {}
      rat.each { |s| session[:rating][s] = 1 }
    end

    @title_header = "hilite" if params["sort"] == "title"
    @release_date_header = "hilite" if params["sort"] == "release_date"
    
    if session[:rating]
      quer = Movie.query(session[:rating])
      @movies = Movie.find(:all, :conditions => quer, order => params[:sort])
    else
      @movies = Movie.all(:order => params[:sort])
    end
    #@movies = Movie.where("rating = ?", params[:rating].keys)
    #@movies = Movie.order(:title).where("rating = ?", params[:rating].keys) if params["sort"] == "title"
    #@movies = Movie.order("release_date ASC").where("rating = ?", params[:rating].keys) if params["sort"] == "release_date"
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
