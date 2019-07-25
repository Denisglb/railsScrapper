class AddInfluncerIdToPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :influencer_id, :integer 
  end
end
