users_no_avatar_ids = User.joins(:user_avatar).where("user_avatars.custom_upload_id is null").select("id").collect(&:id)
users_with_h3d_avatar_ids = H3d::User.where("discourse_user_id is not null").where("avatar_id is not null").select("discourse_user_id").collect(&:discourse_user_id)

users = User.where(id: users_no_avatar_ids & users_with_h3d_avatar_ids)

users.each do |u| 
  puts u.id; u.import_h3d_avatar!;
end
