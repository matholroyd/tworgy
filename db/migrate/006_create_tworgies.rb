class CreateTworgies < ActiveRecord::Migration
  def self.up
    create_table :tworgies do |t|
      t.integer :user_id
      t.integer :twitter_list_id
      t.string :slug
      t.integer :followers_count
      t.integer :following_count
      t.string :uri
      t.decimal :latitude
      t.string :longitude

      t.timestamps
    end
    
    add_index :tworgies, [:user_id, :updated_at]
  end

  def self.down
    drop_table :tworgies
  end
end
