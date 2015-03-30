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

      @post = begin
        if params[:preview]
          Post.find_preview(params[:id])
        else
          Post.published.friendly.find(params[:id])
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end
      
      return super if @post.nil?

      authorize @post
      
      content_for :title, "#{@site.title} | #{@post.title}"

      @comments = @post.comments.order("created_at DESC")
      #allow overriding in the host app
      if params[:preview].nil? && !view_context.current_page?(storytime.post_path(@post))
        redirect_to storytime.post_path(@post), :status => :moved_permanently
      elsif lookup_context.template_exists?("storytime/#{@site.custom_view_path}/#{@post.type_name.pluralize}/#{@post.slug}")
        render "storytime/#{@site.custom_view_path}/#{@post.type_name.pluralize}/#{@post.slug}"
      elsif lookup_context.template_exists?("storytime/#{@site.custom_view_path}/#{@post.type_name.pluralize}/show")
        render "storytime/#{@site.custom_view_path}/#{@post.type_name.pluralize}/show"
      end
    end

    private 

      def set_layout
        if @post.nil?
          HighVoltage.layout
        else
          super
        end
      end
  end
end
