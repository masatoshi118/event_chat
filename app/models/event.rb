class Event < ApplicationRecord
  belongs_to :user

  validates :title, :venue, :datetime, :content,  presence: true
  mount_uploader :event_image, EventImageUploader

end
