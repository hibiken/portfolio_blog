class Article < ActiveRecord::Base
  validates :title, :content, :keywords, presence: true
  extend FriendlyId
  friendly_id :title, use: :slugged
end
