class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.string :email
      t.string :display_name
      t.string :ip
      t.string :body

      t.timestamps
    end
  end
end
