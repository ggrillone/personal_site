class CreateAdminUserAudits < ActiveRecord::Migration
  def change
    enable_extension :hstore

    create_table :admin_user_audits do |t|
      t.integer :admin_user_id
      t.string :ip
      t.string :action
      t.hstore :data

      t.timestamps
    end
  end
end
