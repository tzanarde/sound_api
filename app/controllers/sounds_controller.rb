class SoundsController < ApplicationController
  before_action :authenticate
  before_action :set_sound, only: %i[ show update destroy ]

  def index
    return render json: filtered_sounds, status: :ok
  end

  def show
    render json: @sound, adapter: nil unless @sound.nil?
  end

  def create
    @sound = Sound.new(create_sound_params)

    if @sound.save
      render json: @sound, status: :created, location: @sound
      # NewSoundWorker.perform_async
    else
      render json: @sound.errors, status: :unprocessable_entity
    end
  end

  def update
    if @sound.update(update_sound_params)
      render json: @sound
    else
      render json: @sound.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @sound.destroy
  end

  private

  def set_sound
    @sound = Sound.find_by_id(params[:id])
    render json: { errors: ['sound not found'] }, status: :not_found if @sound.nil?
  end

  def update_sound_params
    params.permit(:name)
  end

  def create_sound_params
    params.permit(:name, :duration, :file_url)
          .merge(user_id: User.find_by_email(request.headers['email']).id)
  end


  def filtered_sounds
    @filter_params = params.permit(:name, :user_id)
    add_name_filter
    add_user_filter

    @filtered_sounds = Sound.where(@filter_params)
  end

  def add_name_filter
    return nil if params[:name].blank?

    @filter_params.merge!(name: params[:name])
  end

  def add_user_filter
    return nil if params[:user_id].blank?

    @filter_params.merge!(user_id: params[:user_id])
  end
end
