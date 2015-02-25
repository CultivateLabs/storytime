class CreateMembershipsForStorytimeUsers < ActiveRecord::Migration
  def change
    Storytime.user_class.find_each do |user|
      if user.storytime_user?
        Storytime::Site.find_each do |site|
          Storytime::Membership.create(site_id: site.id, user_id: user.id, storytime_role_id: user.storytime_role.id)
        end
      end
    end
  end
end
