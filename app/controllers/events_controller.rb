class EventsController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user, only: %i[edit update destroy]

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result.includes(:user)
  end

  def search
    @q = Event.ransack(search_params)
    @events = @q.result.includes(:user)
  end

  def show
    @event = Event.find_by(id: params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    event = current_user.events.create!(event_params)
    # Join.create!(user_id: current_user.id, event_id: event.id)
    redirect_to action: :index
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event.update!(event_params)
    redirect_to root_path
  end

  def destroy
    @event.destroy!
    redirect_to root_path
  end

  private

    def event_params
      params.require(:event).permit(:title, :datetime, :content, :venue, :event_image)
    end

    def correct_user
      @event = current_user.events.find_by(id: params[:id])
      redirect_to root_path if @event.nil?
    end

    def search_params
      params.require(:q).permit(:title_cont, :venue_cont, :datetime_lteq_end_of_day)
    end

end
