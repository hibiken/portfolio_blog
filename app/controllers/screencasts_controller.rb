class ScreencastsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_screencast, only: [:show, :edit, :update, :destroy]

  def index
    @screencasts = Screencast.order(created_at: :desc).paginate(page: params[:page])
  end

  def show
  end

  def new
    @screencast = Screencast.new
  end

  def create
    @screencast = Screencast.new(screencast_params)
    if @screencast.save
      flash[:success] = "Awesome, your video successfully uploaded!"
      redirect_to @screencast
    else
      flash[:danger] = "Oops, something went wrong"
      render :new
    end
  end

  def edit
  end

  def update
    if @screencast.update_attributes(screencast_params)
      flash[:success] = "Cool, it's now updated!"
      redirect_to @screencast
    else
      flash[:danger] = "Oops, something went wrong"
      render :edit
    end
  end

  def destroy
    @screencast.destroy
    flash[:success] = "Successfully deleted the screencast"
    redirect_to screencasts_url
  end

  private

    def get_screencast
      @screencast = Screencast.find(params[:id])
    end

    def screencast_params
      params.require(:screencast).permit(:title, :description)
    end
end
