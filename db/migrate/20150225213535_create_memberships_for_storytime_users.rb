class CreateMembershipsForStorytimeUsers < ActiveRecord::Migration
  def change
    Storytime.user_class.find_each do |user|
      if user.storytime_user?
        Storytime::Site.find_each do |site|
          Storytime::Membership.create(site_id: site.id, user_id: user.id, storytime_role_id: user.storytime_role_id)
          # set as site creator if site.user_id is blank and role is admin
          if site.user_id.blank? && user.storytime_role_id == Storytime::Role.find_by(name: "admin").id
            site.update_column "user_id", user.id
          end
        end
      end
    end

    remove_column Storytime.user_class.table_name.to_sym, :storytime_role_id
  end
end
