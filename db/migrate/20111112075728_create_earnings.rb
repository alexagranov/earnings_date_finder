class CreateEarnings < ActiveRecord::Migration
  def self.up
    create_table :earnings do |t|
      t.string :name
      t.string :cusip
      t.float :estimate
      t.string :at_time

      t.timestamps
    end
  end

  def self.down
    drop_table :earnings
  end
end
