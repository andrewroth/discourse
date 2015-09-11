require_dependency 'validators/stripped_length_validator'
module Validators; end
class Validators::PostValidator < ActiveModel::Validator
  def validate(record)
    presence(record)
    unless Discourse.static_doc_topic_ids.include?(record.topic_id) && record.acting_user.try(:admin?)
      stripped_length(record)
      raw_quality(record)
      max_posts_validator(record)
      max_mention_validator(record)
      max_images_validator(record)
      max_attachments_validator(record)
      max_links_validator(record)
      unique_post_validator(record)
      not_posting_to_category_with_children(record)
    end
  end

  def presence(post)
    [:raw,:topic_id].each do |attr_name|
       post.errors.add(attr_name, :blank, options) if post.send(attr_name).blank?
    end
    if post.new_record? and post.user_id.nil?
      post.errors.add(:user_id, :blank, options)
    end
  end

  def stripped_length(post)
    range = post.topic.try(:private_message?) ? SiteSetting.private_message_post_length : SiteSetting.post_length
    Validators::StrippedLengthValidator.validate(post, :raw, post.raw, range)
  end

  def raw_quality(post)
    sentinel = TextSentinel.body_sentinel(post.raw, private_message: post.topic.try(:private_message?))
    post.errors.add(:raw, I18n.t(:is_invalid)) unless sentinel.valid?
  end

  # Ensure maximum amount of mentions in a post
  def max_mention_validator(post)
    if acting_user_is_trusted?(post)
      add_error_if_count_exceeded(post, :too_many_mentions, post.raw_mentions.size, SiteSetting.max_mentions_per_post)
    else
      add_error_if_count_exceeded(post, :too_many_mentions_newuser, post.raw_mentions.size, SiteSetting.newuser_max_mentions_per_post)
    end
  end

  def max_posts_validator(post)
    if post.new_record? && post.acting_user.present? && post.acting_user.posted_too_much_in_topic?(post.topic_id)
      post.errors.add(:base, I18n.t(:too_many_replies, count: SiteSetting.newuser_max_replies_per_topic))
    end
  end

  # Ensure new users can not put too many images in a post
  def max_images_validator(post)
    add_error_if_count_exceeded(post, :too_many_images, post.image_count, SiteSetting.newuser_max_images) unless acting_user_is_trusted?(post)
  end

  # Ensure new users can not put too many attachments in a post
  def max_attachments_validator(post)
    add_error_if_count_exceeded(post, :too_many_attachments, post.attachment_count, SiteSetting.newuser_max_attachments) unless acting_user_is_trusted?(post)
  end

  # Ensure new users can not put too many links in a post
  def max_links_validator(post)
    add_error_if_count_exceeded(post, :too_many_links, post.link_count, SiteSetting.newuser_max_links) unless acting_user_is_trusted?(post)
  end

  # Stop us from posting the same thing too quickly
  def unique_post_validator(post)
    return if SiteSetting.unique_posts_mins == 0
    return if post.skip_unique_check
    return if post.acting_user.staff?

    # If the post is empty, default to the validates_presence_of
    return if post.raw.blank?

    if post.matches_recent_post?
      post.errors.add(:raw, I18n.t(:just_posted_that))
    end
  end

  # Stop us from posting the same thing too quickly
  def not_posting_to_category_with_children(post)
    return if post.acting_user.try(:admin?)
    post.errors.add(:base, "can't post to a category with children") if post.topic.category.has_children?
  end
 
  private

  def acting_user_is_trusted?(post)
    post.acting_user.present? && post.acting_user.has_trust_level?(TrustLevel[1])
  end

  def add_error_if_count_exceeded(post, key_for_translation, current_count, max_count)
    post.errors.add(:base, I18n.t(key_for_translation, count: max_count)) if current_count > max_count
  end
end
