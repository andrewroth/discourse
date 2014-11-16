class UpdateDiscourseUserLoginToH3dPermalink < ActiveRecord::Migration
  def change
    User.includes(:h3d_user).select("id").each do |u|
      User.where(id: u.id).update_all(username: u.h3d_user.permalink) if u.h3d_user && u.h3d_user.permalink.present?
    end
  end
end
