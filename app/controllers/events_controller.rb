class EventsController < ApplicationController

  before_action :authenticate_user!, only: %i[new create update destroy show]
  before_action :correct_user, only: %i[edit update destroy]
  before_action :event_exist?, only: %i[show edit]

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result.includes(:user).page(params[:page]).per(10)
  end

  def search
    @q = Event.ransack(search_params)
    @events = @q.result.includes(:user).page(params[:page]).per(10)
  end

  def show
    @event = Event.find_by(id: params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      Join.create!(user_id: current_user.id, event_id: @event.id)
      flash[:notice] = '新しいイベントを作成しました。'
      redirect_to @event
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find_by(id: params[:id])
  end

  def update
    @event = Event.find_by(id: params[:id])
    if @event.update(event_params)
      flash[:notice] = "イベントを編集しました。"
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find_by(id: params[:id])
    if @event.destroy
      flash[:notice] = "イベントを削除しました。"
      redirect_to root_path
    else
      flash[:alert] = "トークルームにコメントがある場合削除することができません。"
      render 'show'
    end
  end

  private

    def event_params
      params.require(:event).permit(:title, :datetime, :content, :venue, :event_image)
    end

    def correct_user
      @event = current_user.events.find_by(id: params[:id])
      if @event.nil?
        flash[:alert] = '作成者のみ編集・削除することができます。'
        redirect_to root_path
      end
    end

    def search_params
      params.require(:q).permit(:title_or_content_cont, :venue_cont, :datetime_lteq_end_of_day)
    end

    def event_exist?
      event = Event.find_by(id: params[:id])
      if event.blank?
        flash[:alert] = '指定のURLは存在しないページです。'
        redirect_back(fallback_location: root_path)
      end
    end

end
