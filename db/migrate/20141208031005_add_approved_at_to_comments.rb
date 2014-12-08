class AddApprovedAtToComments < ActiveRecord::Migration
  def change
    add_column :comments, :approved_at, :datetime
  end
end
