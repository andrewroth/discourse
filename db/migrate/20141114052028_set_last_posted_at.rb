class SetLastPostedAt < ActiveRecord::Migration
  def change
    User.connection.execute(%|UPDATE users SET last_posted_at = m.max FROM (SELECT max(posts.created_at) as max, user_id FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id" AND ("posts"."deleted_at" IS NULL) GROUP BY user_id) m WHERE users.id = m.user_id|)
  end
end
