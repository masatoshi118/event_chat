class Event < ApplicationRecord
  belongs_to :user
  has_many :joins, dependent: :destroy
  # event.joined_users で参加しているユーザー一覧が取得できるようになる
  has_many :joined_users, through: :joins, source: :user
  has_many :messages

  validates :title, :venue, :datetime, :content,  presence: true

  mount_uploader :event_image, EventImageUploader

end
