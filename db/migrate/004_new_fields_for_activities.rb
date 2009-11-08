class NewFieldsForActivities < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.datetime :start_at
      t.integer :duration
      t.string :username
      t.string :place
    end
  end

  def self.down
    change_table :activities do |t|
      t.remove :start_at
      t.remove :duration
      t.remove :username
      t.remove :place
    end
  end
end
