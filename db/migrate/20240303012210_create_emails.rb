# This migration creates the emails table that sends emails to sendgrid
class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :emails do |t|
      t.string :from_email
      t.string :from_name
      t.string :to_emails, array: true, default: []
      t.jsonb :substitutions, default: {}, null: true
      t.string :template_id

      t.timestamps
    end
    add_index :emails, :substitutions, using: :gin
  end
end
