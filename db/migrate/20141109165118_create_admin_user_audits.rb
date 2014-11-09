class CreateAdminUserAudits < ActiveRecord::Migration
  def change
    create_table :admin_user_audits do |t|
      t.integer :admin_user_id
      t.string :ip
      t.string :action
      t.string :data

      t.timestamps
    end
  end
end
