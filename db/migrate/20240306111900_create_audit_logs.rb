# This migration file is used to create the audit_logs table in the database.
class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.string :class_name
      t.jsonb :data, default: {}, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :audit_logs, :class_name
    add_index :audit_logs, :data, using: :gin
    add_index :audit_logs, :deleted_at
  end
end
