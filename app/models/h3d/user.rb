module H3d
  class User < ActiveRecord::Base
    establish_connection :h3d

    belongs_to :discourse_user_ref, :foreign_key => "discourse_user_id", :class_name => "::User"

    def discourse_user
      return self.discourse_user_ref if self.discourse_user_ref

      discourse_user = ::User.new
      discourse_user.username = self.login
      discourse_user.email = self.email
      discourse_user.active = true
      discourse_user.admin = self.admin
      discourse_user.save!
      logger.info "[H3d::User id=#{self.id} permalink=#{self.permalink}] create new discourse_user: #{discourse_user.id}"

      self.discourse_user_ref = discourse_user
      self.save!

      return self.discourse_user_ref
    end
  end
end
