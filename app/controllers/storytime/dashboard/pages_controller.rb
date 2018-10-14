require_dependency "storytime/dashboard/posts_controller"

module Storytime
  module Dashboard
    class PagesController < PostsController

    private

      def current_post_type
        @current_post_type ||= Storytime::Page
      end
      helper_method :current_post_type

      def current_dir
        params[:dir]
      end

      def load_posts
        @posts = policy_scope(Storytime::Post).page(params[:page_number]).per(10)
        @posts = @posts.where(type: "Storytime::Page")

        vals = if current_dir.blank?
          ["%", "%/%"]
        else
          ["#{current_dir}/%", "#{current_dir}/%/%"]
        end
        
        @directories = if current_dir.blank?
          @posts.where("slug like ?", vals[0]).pluck(:slug).select{|slug| slug.include?("/") }.map{|slug| slug.split("/").first }.uniq
        else
          @posts.where("slug like ?", vals[1]).pluck(:slug).map{|slug| slug.gsub("#{current_dir}/", "").split("/") }.select{|slug| slug.length > 1 }.map{|slug| slug.first }.uniq
        end

        @posts = @posts.where("slug like ?", vals[0]).where.not("slug like ?", vals[1])

        @posts = if params[:published].present? && params[:published] == 'true'
          @posts.published
        elsif params[:draft].present? && params[:draft] == "true"
          @posts.draft
        else
          @posts
        end
      end
    end
  end
end
