class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.title :string

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
