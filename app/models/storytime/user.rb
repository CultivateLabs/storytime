module Storytime
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

    belongs_to :role
    has_many :posts
    has_many :pages
    has_many :media
    has_many :versions

    after_create :assign_first_admin

    def admin?
      role && role.name == "admin"
    end

    def assign_first_admin
      if User.count == 1
        admin_role = Role.find_by(name: "admin")
        admin_role.users << self
      end
    end
  end
end