class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :email_address, :salt, :encrypted_password, :verification_key
      t.boolean :activated, :default => false
      t.boolean :banned, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
