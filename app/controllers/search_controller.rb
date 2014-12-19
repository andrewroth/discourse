require_dependency 'search'

class SearchController < ApplicationController
  include ActionView::Helpers::UrlHelper
  skip_before_filter :check_xhr, :only => :query

  def self.valid_context_types
    %w{user topic category}
  end

  def query

    params[:term] = params.delete(:q) if params[:q]
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

    search_args[:per_facet] = 10 unless request.xhr?

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

      @autocomplete_array = (posts + topics + users + categories).collect{ |r| 
        case r
        when Topic
          label = render_to_string(partial: "topic", locals: { result: result, t: r })
        when Post
          label = render_to_string(partial: "post", locals: { result: result, p: r })
        when User
          label = render_to_string(partial: "user", locals: { result: result, u: r })
        when Category
          label = render_to_string(partial: "category", locals: { result: result, c: r })
        end

        { 
          "class_name" => r.class.name, 
          "id" => r.id, 
          "label" => label,
          "value" => r.id, 
          "url" => r.relative_url
        }
      }

      respond_to do |format|
        format.js do
          render :text => @autocomplete_array.to_json
        end
        format.html do
          @no_ember = true
          render "search/query"
        end
      end
    else
      render_serialized(result, GroupedSearchResultSerializer, :result => result)
    end
  end

end
