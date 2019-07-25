class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
    	t.string :tag_name
		t.integer :popularity_of_tag
		t.string :page_info
    	t.string :user
		t.string :comment
		t.integer :comment_count
		t.integer :like_count
		t.string :owner_id
		t.string :date_added
		t.string :accessibility_caption
      t.timestamps
    end
  end
end
