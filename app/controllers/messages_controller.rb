class MessagesController < ApplicationController
  before_action :correct_user, only: :destroy

  def create
    event = Event.find(params[:event_id].to_i)
    m_params = message_params
    m_params[:user_id] = current_user.id
    @message = event.messages.create!(m_params)
    #投稿されたメッセージをチャット参加者に配信
    ActionCable.server.broadcast 'room_channel', message: @message.template
  end

  def destroy
    message = Message.find(params[:id])
    if message.user == current_user
      @message.destroy
      flash[:success]="メッセージを削除しました。"
      redirect_to request.referrer || root_url
    else
      flash[:alart]="投稿者のみ削除することができます。"
      redirect_to request.referrer
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def correct_user
    @message = current_user.messages.find_by(id: params[:id])
    flash[:notice]="投稿者のみ削除することができます。"
    redirect_to request.referrer || root_url if @message.nil?
  end

end
