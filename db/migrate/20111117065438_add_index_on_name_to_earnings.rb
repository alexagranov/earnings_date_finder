class AddIndexOnNameToEarnings < ActiveRecord::Migration
  def self.up
    add_index :earnings, :name, :name => 'by_name'
  end

  def self.down
    remove_index :earnings, :name => 'by_name'
  end
end
