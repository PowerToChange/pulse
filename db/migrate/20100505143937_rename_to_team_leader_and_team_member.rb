class RenameToTeamLeaderAndTeamMember < ActiveRecord::Migration
  DELETE_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Leader", :controller => "stats", :action => "semester_highlights" }]
  RENAME_MINISTRY_ROLES = [{ :old_name => "Campus Coordinator", :new_name => "Team Leader" }, 
                         { :old_name => "Staff Team", :new_name => "Team Member" }]

  DELETE_STAFF_ROLE = [
              { 
                :ministry_id => 1, 
                :name => "Team Leader", 
                :position => 6, 
                :description => "", 
                :involved => 1
              }
            ]
  UPDATE_STAFF_ROLE_POSITION = [{:name => "Campus Coordinator", :position => 6, :oldposition => 5}, 
                                {:name => "Team Leader", :position => 10, :oldposition => 6}]


  def self.up
    DELETE_MINISTRY_ROLE_PERMISSIONS.each do | mrp |
      p_id = Permission.find(:first, :conditions => { 
                                                        :controller => mrp[:controller], 
                                                        :action => mrp[:action] } ).id
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      MinistryRolePermission.find(:first, :conditions => { :permission_id => p_id, 
                                                           :ministry_role_id => mr_id }).destroy
    end
  
    UPDATE_STAFF_ROLE_POSITION.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:name] })
      if r
        r[:position] = role[:position]
        r.save!
      end
    end
  
    DELETE_STAFF_ROLE.each do | mr |
      StaffRole.find(:first, :conditions => { :name => mr[:name] } ).destroy
    end

    RENAME_MINISTRY_ROLES.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:old_name] })
      if r
        r[:name] = role[:new_name]
        r.save!
      end
    end

    
  end

  def self.down
  
    RENAME_MINISTRY_ROLES.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:new_name] })
      if r
        r[:name] = role[:old_name]
        r.save!
      end
    end

    DELETE_STAFF_ROLE.each do |role|
      StaffRole.create!(role)
    end
  
    UPDATE_STAFF_ROLE_POSITION.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:name] })
      if r
        r[:position] = role[:oldposition]
        r.save!
      end
    end
  
    DELETE_MINISTRY_ROLE_PERMISSIONS.each do | mrp |
      p_id = Permission.find(:first, :conditions => { 
                                                        :controller => mrp[:controller], 
                                                        :action => mrp[:action] }).id
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] }).id
      MinistryRolePermission.create!({ :permission_id => p_id, :ministry_role_id => mr_id })
    end
  
end
end