class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :domain, :api_key, :email_address, :support_title
      t.text :activation_letter, :recovery_letter
      t.timestamps
    end
    
    change_table :accounts do |t|
      t.integer :site_id
    end
  end

  def self.down
    drop_table :sites
    
    change_table :accounts do |t|
      t.remove :site_id
    end
  end
end
