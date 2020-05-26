class Message < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :content, presence: true

  def template
    ApplicationController.render_with_signed_in_user(user, partial: 'messages/message', locals: { message: self })
  end

end
