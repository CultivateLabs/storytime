class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :storytime_role, class_name: "Storytime::Role"
  has_many :storytime_posts, class_name: "Storytime::Post"
  has_many :storytime_pages, class_name: "Storytime::Page"
  has_many :storytime_media, class_name: "Storytime::Media"
  has_many :storytime_versions, class_name: "Storytime::Version"

  def admin?
    storytime_role && storytime_role.name == "admin"
  end
  
end
