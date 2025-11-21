class CreateSocialMediaPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :social_media_posts do |t|
      t.string :title, null: false
      t.text :content
      t.string :hashtags, array: true, default: []
      t.string :platforms_posted, array: true, default: []
      t.jsonb :post_url_per_platform, default: {}
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
