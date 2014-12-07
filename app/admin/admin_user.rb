ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
  actions :all, except: [:show, :new, :create,:destroy]
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  controller do
    ##
    # Override the default update action.
    # To fix 2 issues.
    # 1. When updating your own user it was logging that user out.
    # 2. Make it so updating the user password is not required.
    def update
      @admin_user = AdminUser.find(params[:id])

      successfully_updated = if needs_password?(@admin_user, params)
        @admin_user.update_with_password(permitted_params[:admin_user])
      else
        # remove the virtual current_password attribute
        # update_without_password doesn't know how to ignore it
        params[:admin_user].delete(:current_password)
        @admin_user.update_without_password(permitted_params[:admin_user])
      end

      if successfully_updated
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
    column :created_at
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
