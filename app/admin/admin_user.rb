ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
  actions :all, except: [:show, :new, :create,:destroy]
  config.filters = false
  config.sort_order = 'email_asc'

  controller do
    ##
    # Override the default update action.
    # To fix 2 issues.
    # 1. When updating your own user it was logging that user out.
    # 2. Make it so updating the user password is not required.
    def update
      @admin_user = AdminUser.find(params[:id])
      original_attributes = @admin_user.attributes

      successfully_updated = if needs_password?(@admin_user, params)
        @admin_user.update_with_password(permitted_params[:admin_user])
      else
        # remove the virtual current_password attribute
        # update_without_password doesn't know how to ignore it
        params[:admin_user].delete(:current_password)
        @admin_user.update_without_password(permitted_params[:admin_user])
      end


      if successfully_updated
        # Auditing
        action = params[:action]
        changes = []
        blacklist = ['password', 'password_confirmation', 'current_password', 'updated_at'] # exclude specific attributes
        new_attributes = @admin_user.attributes
        original_attributes.keys.each do |key|
          if !blacklist.include?(key.to_s) && original_attributes[key] != new_attributes[key]
            changes.push({ :"#{key.to_sym}" => { original_value: original_attributes[key], new_value: new_attributes[key] } })
          end
        end
        # TODO: cleanse params of values we don't want to expose
        data = {
          http_method: request.method,
          params: params,
          changes: changes
        }
        a = AdminUserAudit.create(admin_user_id: current_admin_user.id, action: action, data: data, ip: request.ip)
        Rails.logger.info '------ LOGGGG  ---'
        Rails.logger.info a.attributes

        # Need to re-query the currently signed in Admin because
        # the helper we are given (current_admin_user) doesn't seem to get
        # updated automatically so it tries to sign in with the previous password
        admin_user_current = AdminUser.find(current_admin_user.id)
        # Sign in the user bypassing validation in case their password changed
        sign_in admin_user_current, :bypass => true
        flash[:notice] = "Your account has been updated successfully."
        redirect_to admin_admin_users_path
      else
        render "edit"
      end
    end

    private

      # check if we need password to update user data
      # ie if password or email was changed
      # extend this as needed
      def needs_password?(admin_user, params)
        params[:admin_user][:password].present? ||
          params[:admin_user][:password_confirmation].present?
      end
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at do |admin_user|
      admin_user.created_at.strftime("%B, %e %Y %H:%M")
    end
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Admin Details" do
      f.input :email
    end

    f.inputs 'Change Password' do
      f.input :current_password, label: 'Current Password (only required when updating password)'
      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end
end
