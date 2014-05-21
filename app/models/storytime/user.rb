module Storytime
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

    # enum role: [ :writer, :editor, :admin ]

    belongs_to :role
    has_many :posts
    has_many :pages
    has_many :media
    has_many :versions

    def admin?
      role && role.name == "admin"
    end
  end
end