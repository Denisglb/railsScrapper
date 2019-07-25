class CreateInfluencers < ActiveRecord::Migration[5.1]
  def change
    create_table :influencers do |t|
    	t.string :user
		t.string :biography
		t.string :followers
		t.string :following
		t.string :businessAcounnt
		t.string :businessCategory
		t.string :numberOfPosts
		t.string :page_info
      t.timestamps
    end
  end
end
