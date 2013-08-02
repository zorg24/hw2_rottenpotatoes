class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    #debugger
    #logger.info("Session start:" + session.inspect)
    # redirect if needed
    if (!params.key?(:sort) && session.key?(:sort)) || (!params.key?(:ratings) && session.key?(:ratings))
      #logger.info("Hiiiiiiiiiiiiiiiiiiii!!!!!!!!!!")
      flash.keep
      redirect_to :action => 'index', :sort => params.key?(:sort) ? params[:sort] : session[:sort], :ratings => params.key?(:ratings) ? params[:ratings] : session[:ratings]
    end

    # update session
    session[:sort] = params.key?(:sort) ? params[:sort] : session[:sort]
    session[:ratings] = params.key?(:ratings) ? params[:ratings] : session[:ratings]

    if session[:ratings].nil?
      rat = Movie.ratings
      session[:ratings] = {}
      rat.each { |s| session[:ratings][s] = 1 }
      #debugger
    end

    @title_header = "hilite" if params["sort"] == "title"
    @release_date_header = "hilite" if params["sort"] == "release_date"
    
    if session[:ratings]
      quer = Movie.query(session[:ratings])
      @movies = Movie.order(params[:sort].to_s).where(quer)
    else
      @movies = Movie.all(:order => params[:sort])
    end
    #@movies = Movie.where("rating = ?", params[:ratings].keys)
    #@movies = Movie.order(:title).where("rating = ?", params[:ratings].keys) if params["sort"] == "title"
    #@movies = Movie.order("release_date ASC").where("rating = ?", params[:ratings].keys) if params["sort"] == "release_date"
    #debugger
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
