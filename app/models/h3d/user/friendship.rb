class H3d::User::Friendship < ActiveRecord::Base
  belongs_to :user, :class_name => "H3d::User"
  belongs_to :friend, :class_name => "H3d::User"

  scope :reciprocated, -> { where('user_id IN (SELECT friend_id FROM user_friendships friend WHERE user_friendships.friend_id = friend.user_id)') }
  scope :unreciprocated, -> { where('user_id NOT IN (SELECT friend_id FROM user_friendships friend WHERE user_friendships.friend_id = friend.user_id)') }
end
