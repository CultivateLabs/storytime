require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    include HighVoltage::StaticPage

    layout :set_layout

    def index
      @posts = Post.where(type: Storytime.post_types.reject{|type| %w[Storytime::Page Storytime::Blog].include?(type) }).tagged_with(params[:tag]).page(params[:page_number]).per(10)
    end

    def show
      params[:id] = params[:id].split("/").last

      return super unless Post.friendly.exists? params[:id]

      @post = if params[:preview]
        Post.find_preview(params[:id])
      else
        Post.published.friendly.find(params[:id])
      end

      authorize @post
      
      content_for :title, "#{@current_storytime_site.title} | #{@post.title}"

      @comments = @post.comments.order("created_at DESC")
      #allow overriding in the host app
      if params[:preview].nil? && !view_context.current_page?(storytime.post_path(@post))
        redirect_to storytime.post_path(@post), :status => :moved_permanently
      elsif lookup_context.template_exists?("storytime/#{@current_storytime_site.custom_view_path}/#{@post.type_name.pluralize}/#{@post.slug}")
        render "storytime/#{@current_storytime_site.custom_view_path}/#{@post.type_name.pluralize}/#{@post.slug}"
      elsif lookup_context.template_exists?("storytime/#{@current_storytime_site.custom_view_path}/#{@post.type_name.pluralize}/show")
        render "storytime/#{@current_storytime_site.custom_view_path}/#{@post.type_name.pluralize}/show"
      end
    end

    private 

      def set_layout
        if Post.friendly.exists? params[:id]
          super
        else
          HighVoltage.layout
        end
      end
  end
end
