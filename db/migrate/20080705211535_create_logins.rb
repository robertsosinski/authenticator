class CreateLogins < ActiveRecord::Migration
  def self.up
    create_table :logins do |t|
      t.belongs_to :account
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :logins
  end
end
