ActiveAdmin.register AdminUserAudit do
  actions :all, except: [:edit, :update, :destroy, :new, :create]

  index do
    selectable_column

    column :id
    column 'Admin User' do |admin_user_audit|
      admin_user_audit.admin_user.email
    end
    column :action
    column :ip
    column :created_at do |admin_user_audit|
      admin_user_audit.created_at.strftime("%B, %e %Y %H:%M")
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row 'Admin User' do
        admin_user_audit.admin_user.email
      end
      row :action
      row :ip
      row :data
      row :created_at do
        admin_user_audit.created_at.strftime("%B, %e %Y %H:%M")
      end
      row :updated_at do
        admin_user_audit.updated_at.strftime("%B, %e %Y %H:%M")
      end
    end
  end
end