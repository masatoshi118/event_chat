class JoinsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_others_event

  def create
    current_user.joins.create!(event_id: params[:event_id])
    redirect_to event_path(id: params[:event_id])
  end

  def destroy
    current_user.joins.find_by(event_id: params[:event_id]).destroy!
    redirect_to event_path(id: params[:event_id])
  end

  private

  def check_others_event
    if Event.find(params[:event_id]).user_id == current_user.id
      redirect_to root_path
    end
  end

end