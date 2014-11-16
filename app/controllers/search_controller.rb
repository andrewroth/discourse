require_dependency 'search'

class SearchController < ApplicationController
  include ActionView::Helpers::UrlHelper

  def self.valid_context_types
    %w{user topic category}
  end

  def query
    params.require(:term)

    search_args = {guardian: guardian}
    search_args[:type_filter] = params[:type_filter] if params[:type_filter].present?
    if params[:include_blurbs].present?
      search_args[:include_blurbs] = params[:include_blurbs] == "true"
    end
    search_args[:search_for_id] = true if params[:search_for_id].present?

    search_context = params[:search_context]
    if search_context.present?
      raise Discourse::InvalidParameters.new(:search_context) unless SearchController.valid_context_types.include?(search_context[:type])
      raise Discourse::InvalidParameters.new(:search_context) if search_context[:id].blank?

      klass = search_context[:type].classify.constantize

      # A user is found by username
      context_obj = nil
      if search_context[:type] == 'user'
        context_obj = klass.find_by(username_lower: params[:search_context][:id].downcase)
      else
        context_obj = klass.find_by(id: params[:search_context][:id])
      end

      guardian.ensure_can_see!(context_obj)
      search_args[:search_context] = context_obj
    end

    search = Search.new(params[:term], search_args.symbolize_keys)
    result = search.execute

    if params[:h3d_autocomplete] == "true" || params[:h3d_autocomplete] == true
      posts = result.posts.to_a
      topics = posts.collect(&:topic).uniq
      # remove any topics for which the first post already is included in the results
      topics.reject!{ |t| posts.include?(t.posts.first) }
      users = result.users.to_a
      categories = result.categories.to_a
=begin
      render :text => (posts + topics + users + categories).collect{ |r| { 
        "id" => r.id, "label" => "<div>#{r.class.name}: #{r.id}</div>".encode("ISO-8859-1").html_safe, "value" => r.id }
      }.to_json.encode("ISO-8859-1").html_safe
=end

      lock_html = %|<img class='locked_topic' src='/assets/discourse_lock.png'></img>|
      render :text => (posts + topics + users + categories).collect{ |r| 
        case r
        when Topic
          label = "<div style='line-height: normal; color: #828282'><span class='linklike'>#{lock_html if true || r.closed} #{r.title.gsub(/#{params[:term]}/i) { |s| "<b class='darker'>#{s}</b>"}}</span><br/>"
          label += "#{r.created_at.strftime("%m, %Y")}"
          label += " - #{result.blurb(r.posts.first).gsub(/#{params[:term]}/i) { |s| "<b class='darker black'>#{s}</b>" }}"
          label += "</div>"
        when Post
          label = "<div style='line-height: normal; color: #828282'><span class='linklike'>#{lock_html if true || r.topic.closed} #{r.topic.title.gsub(/#{params[:term]}/i) { |s| "<b class='darker'>#{s}</b>" }}</span><br/>"
          label += "#{r.topic.created_at.strftime("%m, %Y")}"
          label += " - #{result.blurb(r).gsub(/#{params[:term]}/i) { |s| "<b class='darker black'>#{s}</b>" }}"
          label += "</div>"
        when User
          label = "<div><img class='avatar' width='25' height='25' title='#{r.to_s}' src='#{r.avatar_template.sub('{size}', '25')}'></img>#{r.to_s}</div>".html_safe
        when Category
          label = "<div><span style='background-color: ##{r.color}; color: ##{r.text_color}; ' title='#{r.description.present? ? r.description :  r.name}' class='badge-category' data-drop-close='true' href='#{r.relative_url}'>#{r.name}</span></div>"
        end

        { 
          "class_name" => r.class.name, 
          "id" => r.id, 
          #"label" => "<div>#{r.class.name}: #{r.id}</div>".html_safe, 
          "label" => label,
          "value" => r.id, 
          "url" => r.relative_url
        }
      }.to_json
    else
      render_serialized(result, GroupedSearchResultSerializer, :result => result)
    end
  end

end
