class AddCounterCacheForLogins < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.integer :logins_count, :default => 0
    end
    
    Account.all.each do |a|
      a.update_attribute(:logins_count, a.logins.length)
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :logins_count
    end
  end
end
