class DefaultTworgyValues < ActiveRecord::Migration
  def self.up
    change_column :tworgies, :latitude, :decimal, :precision => 15, :scale => 11
    change_column :tworgies, :longitude, :decimal, :precision => 15, :scale => 11
    
    Tworgy.all.each do |tworgy|
      tworgy.enabled = true if tworgy.enabled.nil?
      tworgy.save!
    end
  end

  def self.down
    change_column :tworgies, :latitude, :string
    change_column :tworgies, :longitude, :string
  end
end
