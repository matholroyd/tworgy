class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts, :force => true do |t|
      t.column :title, :string
      t.column :factual, :text
      t.column :fictional, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
