class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :room_exist?
  before_action :joining_user?

  def show
    @event = Event.find_by(id: params[:id])
    @messages = Message.where(event_id: params[:id]).order(:id).last(50)
    @message = current_user.messages.build
  end

  private
  def joining_user?
    event = Event.find_by(id: params[:id])
    unless event.joined_users.include?(current_user)
      flash[:alert] = 'イベント参加者のみメッセージを見ることができます。'
      redirect_back(fallback_location: root_path)
    end
  end

  def room_exist?
    event = Event.find_by(id: params[:id])
    if event.blank?
      flash[:alert] = '指定のURLは存在しないページです。'
      redirect_back(fallback_location: root_path)
    end
  end
end
