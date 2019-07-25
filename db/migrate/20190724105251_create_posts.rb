class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :user
	  t.string :caption
	  t.integer :noOfComments
	  t.string :postedTime
	  t.integer :likes
	  t.string :location
	  t.string :ownerOfPost
	  t.string :isVideo
	  t.string :videoViews
      t.timestamps
    end
  end
end
