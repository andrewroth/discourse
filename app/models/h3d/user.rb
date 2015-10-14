module H3d
  class User < ActiveRecord::Base
    establish_connection :h3d

    belongs_to :discourse_user_ref, :foreign_key => "discourse_user_id", :class_name => "::User"
    belongs_to :avatar, :foreign_key => :avatar_id, :class_name => 'H3d::FileAsset'

    has_many :messages_sent, class_name: 'Message', foreign_key: 'sender_id'
    has_many :messages_received, class_name: 'Message', foreign_key: 'recipient_id'

    # START SOCIAL SECTION

    has_many :friendships do
      def pending? ; pending.count > 0 ; end
    end

    has_many :reciprocated_friends, -> { where("user_id IN (SELECT friend_id FROM user_friendships friend WHERE user_friendships.friend_id = friend.user_id)") }, :through => :friendships, :source => :friend
    has_many :friends, -> { where("user_id IN (SELECT friend_id FROM user_friendships friend WHERE user_friendships.friend_id = friend.user_id)") }, :through => :friendships, :source => :friend

    # this user is requesting friendships from others
    has_many :requested_friendships, -> { where("user_id NOT IN (SELECT friend_id FROM user_friendships friend WHERE user_friendships.friend_id = friend.user_id)") }, :class_name => '::User::Friendship'
    has_many :others_requesting_friendships, -> { where("user_id NOT IN (SELECT friend_id FROM user_friendships friend WHERE user_friendships.friend_id = friend.user_id)") }, foreign_key: 'friend_id', :class_name => '::User::Friendship'

    # END SOCIAL SECTION

    def discourse_user
      return self.discourse_user_ref if self.discourse_user_ref

      discourse_user = ::User.new
      discourse_user.username = self.permalink || self.id.to_s
      discourse_user.email = self.email
      discourse_user.active = true
      discourse_user.admin = self.admin
      discourse_user.created_at = self.created_at || (@@min_created_at ||= H3d::User.minimum(:created_at))
      discourse_user.save!
      logger.info "[H3d::User id=#{self.id} permalink=#{self.permalink}] create new discourse_user: #{discourse_user.id}"

      self.discourse_user_ref = discourse_user
      self.save!

      discourse_user.import_h3d_avatar!

      return self.discourse_user_ref
    end

    def to_s
      return @to_s if @to_s
      s = case self.display_name
          when 'name'
            name.present? ? name : login
          else
            login
          end
      @to_s = s.present? ? s.strip : ''
    end

    def name
      fullname
    end
    alias :nickname :name
  end
end
