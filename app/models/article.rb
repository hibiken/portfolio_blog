class Article < ActiveRecord::Base
  validates :title, :content, :keywords, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PgSearch
  pg_search_scope :fulltext_search, :against => { :title => 'A', :keywords => 'A', :content => 'D' },
                                    :using => { tsearch: { dictionary: 'english' } }

end
