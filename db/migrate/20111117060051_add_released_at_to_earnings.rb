class AddReleasedAtToEarnings < ActiveRecord::Migration
  def self.up
    add_column :earnings, :released_at, :datetime

    add_index :earnings, [:name, :released_at], :unique => true, :name => 'uniq_by_name_and_released'
  end

  def self.down
    remove_index :earnings, :name => 'uniq_by_name_and_released'

    remove_column :earnings, :released_at
  end
end
