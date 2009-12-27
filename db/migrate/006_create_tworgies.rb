class CreateTworgies < ActiveRecord::Migration
  def self.up
    create_table :tworgies do |t|
      t.integer :user_id
      t.integer :twitter_list_id
      t.string :name
      t.string :slug
      t.integer :members_count
      t.integer :subscribers_count
      t.string :uri
      t.string :latitude
      t.string :longitude
      t.boolean :enabled

      t.timestamps
    end
    
    add_index :tworgies, [:user_id, :updated_at]
  end

  def self.down
    drop_table :tworgies
  end
end
