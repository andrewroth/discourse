module H3d
  class User < ActiveRecord::Base
    establish_connection :h3d

    belongs_to :discourse_user_ref, :foreign_key => "discourse_user_id", :class_name => "::User"
    belongs_to :avatar, :foreign_key => :avatar_id, :class_name => 'H3d::FileAsset'

    has_many :messages_sent, class_name: 'Message', foreign_key: 'sender_id'
    has_many :messages_received, class_name: 'Message', foreign_key: 'recipient_id'

    def discourse_user
      return self.discourse_user_ref if self.discourse_user_ref

      discourse_user = ::User.new
      discourse_user.username = self.permalink
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
