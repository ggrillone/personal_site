ActiveAdmin.register Tag do
  permit_params :name, :admin_user_id
  actions :all, except: [:show]
  includes :blog_post_tags
  filter :name

  controller do
    def create
      @tag = Tag.new(permitted_params[:tag])

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
    column :count
    column :created_at do |tag|
      tag.created_at.strftime("%B, %e %Y %H:%M")
    end
    column :updated_at do |tag|
      tag.updated_at.strftime("%B, %e %Y %H:%M")
    end

    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Tag details' do
      f.input :name
      f.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
    end

    f.actions
  end
end