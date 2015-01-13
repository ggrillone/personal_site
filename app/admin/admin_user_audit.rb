ActiveAdmin.register AdminUserAudit do
  actions :all, except: [:edit, :update, :destroy, :new, :create]
  includes :admin_user
  filter :action
  filter :created_at
  config.sort_order = 'created_at_desc'

  scope :all, default: true
  scope 'Create', :create_action
  scope 'Update', :update_action
  scope 'Delete', :delete_action

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
      row 'changed attributes' do
        if JSON.parse(admin_user_audit.data['raw_data'])['changes'].present?
          JSON.parse(admin_user_audit.data['raw_data'])['changes'].each do |change|
            div do
              div do
                "Attribute: #{change.keys.first}" # we can assume there will always be 1 key
              end

              div do
                "Previous value: #{change[change.keys.first]['original_value']}"
              end

              div do
                "New value: #{change[change.keys.first]['new_value']}"
              end
            end

            hr
          end
        else
          nil
        end
      end
      row :ip
      row 'raw data' do
        admin_user_audit.data
      end
      row :created_at do
        admin_user_audit.created_at.strftime("%B, %e %Y %H:%M")
      end
      row :updated_at do
        admin_user_audit.updated_at.strftime("%B, %e %Y %H:%M")
      end
    end
  end
end