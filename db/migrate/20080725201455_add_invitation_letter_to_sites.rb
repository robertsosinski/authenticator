class AddInvitationLetterToSites < ActiveRecord::Migration
  def self.up
    change_table :sites do |t|
      t.string :invitation_subject
      t.text :invitation_letter
    end
  end

  def self.down
    change_table :sites do |t|
      t.remove :invitation_subject, :invitation_letter
    end
  end
end
