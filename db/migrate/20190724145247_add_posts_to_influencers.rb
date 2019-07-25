class AddPostsToInfluencers < ActiveRecord::Migration[5.1]
  def change
    add_reference :influencers, :posts, foreign_key: true
  end
end