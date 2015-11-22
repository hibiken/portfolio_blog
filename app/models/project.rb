class Project < ActiveRecord::Base
  validates :title, :description, :link, presence: true
  extend FriendlyId
  friendly_id :title, use: :slugged

  mount_uploader :image, ImageUploader
end
