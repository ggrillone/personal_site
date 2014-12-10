if Rails.env.development?
  require 'faker'
  I18n.reload!

  AdminUser.destroy_all
  AdminUserAudit.destroy_all
  BlogPost.destroy_all
  Comment.destroy_all
  BlogPostTag.destroy_all
  Tag.destroy_all
  SocialMedia.destroy_all

  admin_user = AdminUser.create(email: 'greg@me.com', password: 'Password01', password_confirmation: 'Password01')
  10.times { Fabricate(:admin_user_audit, admin_user_id: admin_user.id) }
  Fabricate(:blog_post, cover_image: 'sample.png')
end