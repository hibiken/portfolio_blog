class AddYoutubeUrlToScreencasts < ActiveRecord::Migration
  def change
    add_column :screencasts, :youtube_url, :string
  end
end
