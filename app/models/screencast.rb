class Screencast < ActiveRecord::Base
  validates :title, presence: true
end
