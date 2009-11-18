class AddingOauthSupport < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :twitter_username
      t.string :oauth_token
      t.string :oauth_secret
      t.boolean :admin
    end
  
    add_index :users, :oauth_token

    change_column :users, :email, :string, :default => nil, :null => true
    change_column :users, :crypted_password, :string, :default => nil, :null => true
    change_column :users, :password_salt, :string, :default => nil, :null => true
  end

  def self.down
    remove_index :users, :oauth_token

    remove_column :users, :twitter_username
    remove_column :users, :oauth_token
    remove_column :users, :oauth_secret
    remove_column :users, :admin

    [:email, :crypted_password, :password_salt].each do |field|
      User.all(:conditions => "#{field} is NULL").each { |user| user.update_attribute(field, "") if user.send(field).nil? }
      change_column :users, field, :string, :default => "", :null => false
    end
  end
end
