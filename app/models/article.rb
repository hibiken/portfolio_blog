class Article < ActiveRecord::Base
  validates :title, :content, :keywords, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  # will_paginate gem
  self.per_page = 5

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PgSearch
  pg_search_scope :fulltext_search, :against => { :title => 'A', :keywords => 'A', :content => 'D' },
                                    :using => { tsearch: { dictionary: 'english' } }


  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :drafts,    -> { where(published: false) }

end
