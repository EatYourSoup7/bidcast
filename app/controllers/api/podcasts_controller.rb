class Api::PodcastsController < ApplicationController
  before_action :authenticate_podcast, except: [:index, :show, :create]
  
  
  def index
    @podcasts = Podcast.all
    render "index.json.jb"
  end

  def create
    @podcast = Podcast.new(
                    name: params[:name],
                    description: params[:description],
                    email: params[:email],
                    image: params[:image],
                    password: params[:password],
                    password_confirmation: params[:password_confirmation],
                    type: params[:type],
                    youtube_url: params[:youtube_url]
                    )
    @podcast.youtube_embed
    if @podcast.save
      render json: { message: "Podcast created successfully" }, status: :created
    else
      render json: { errors: podcast.errors.full_messages }, status: :bad_request
    end

  end

  def show
    @podcast = Podcast.find(params[:id])
    render 'show.json.jb'
  end

  def update
    @podcast = Podcast.find(params[:id])

    @podcast.name = params[:name] || @podcast.name
    @podcast.description = params[:description] || @podcast.description
    @podcast.email = params[:email] || @podcast.email
    @podcast.youtube_url = params[:youtube_url] || @podcast.youtube_url

    @podcast.youtube_embed

    if @podcast.save
      render "show.json.jb"
    else
      render json: { errors: @podcast.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy

    podcast = Podcast.find(params[:id])
    podcast.delete
    render json: {message: "Podcast ID #{podcast.id} successfully deleted."}
  end

end
