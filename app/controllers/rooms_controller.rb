class RoomsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @messages = Message.where(event_id: params[:id]).order(:id).last(50)
    @message = current_user.messages.build
  end
end
