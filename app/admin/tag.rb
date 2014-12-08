ActiveAdmin.register Tag do
  permit_params :name
  actions :all, except: [:show]
  filter :name

  controller do
    def create
      @tag = Tag.new(permitted_params[:tag])
      @tag.admin_user_id = current_admin_user.id

      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        redirect_to admin_tags_path
      else
        render 'new'
      end
    end
  end

  index do
    selectable_column

    column :id
    column :name
    column :created_at do |tag|
      tag.created_at.strftime("%B, %e %Y %H:%M")
    end
    column :updated_at do |tag|
      tag.updated_at.strftime("%B, %e %Y %H:%M")
    end

    actions
  end
end