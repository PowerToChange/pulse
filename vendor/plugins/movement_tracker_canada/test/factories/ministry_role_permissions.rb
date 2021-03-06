Factory.define :ministryrolepermission_1, :class => MinistryRolePermission do |m|
  m.id '1'
  m.ministry_role_id '1'
  m.permission_id '2'
end

Factory.define :ministryrolepermission_2, :class => MinistryRolePermission do |m|
  m.id '2'
  m.ministry_role_id '2'
  m.permission_id '1'
end

Factory.define :ministryrolepermission_4, :class => MinistryRolePermission do |m|
  m.id '4'
  m.ministry_role_id '4'
  m.permission_id '4'
end

Factory.define :ministryrolepermission_5, :class => MinistryRolePermission do |m|
  m.id '5'
  m.ministry_role_id '10'
  m.permission_id '4'
end

Factory.define :ministryrolepermission_6, :class => MinistryRolePermission do |m|
  m.id '6'
  m.ministry_role_id '5'	# Ministry Leader
  m.permission_id '4'
end

Factory.define :ministryrolepermission_7, :class => MinistryRolePermission do |m|
  m.id '7'
  m.ministry_role_id '4'
  m.permission_id '7'
end

=begin
Factory.define :ministryrolepermission_7, :class => MinistryRolePermission do |m|
  m.id '7' # hobbe's version???  not sure where this came from exactly.  It got mixed up in some merges.
  m.ministry_role_id '10'
  m.permission_id '5'
end
=end

Factory.define :ministryrolepermission_8, :class => MinistryRolePermission do |m|
  m.id '8' # this also comes from Hobbe's version, somewhere.  It got mixed up in some merges.
  m.ministry_role_id '5'	# Ministry Leader
  m.permission_id '4'
end

Factory.define :ministryrolepermission_9, :class => MinistryRolePermission do |m|
  m.id '9' # Hobbe's version, originally 7
  m.ministry_role_id '4'
  m.permission_id '7'
end

Factory.define :ministryrolepermission_11, :class => MinistryRolePermission do |m|
  m.id '11'
  m.ministry_role_id '4'
  m.permission_id '11'
end

Factory.define :ministryrolepermission_12, :class => MinistryRolePermission do |m|
  m.id '12'
  m.ministry_role_id '4'
  m.permission_id '12'
end

Factory.define :ministryrolepermission_13, :class => MinistryRolePermission do |m|
  m.id '13'
  m.ministry_role_id '7'    #student
  m.permission_id '11'
end

Factory.define :ministryrolepermission_14, :class => MinistryRolePermission do |m|
  m.id '14'
  m.ministry_role_id '7'    #student
  m.permission_id '9'
end

Factory.define :ministryrolepermission_15, :class => MinistryRolePermission do |m|
  m.id '15'
  m.ministry_role_id '4'    #ministry leader
  m.permission_id '10'
end

Factory.define :ministryrolepermission_16, :class => MinistryRolePermission do |m|
  m.id '16'
  m.ministry_role_id '5'    #student leader
  m.permission_id '12'
end

Factory.define :ministryrolepermission_17, :class => MinistryRolePermission do |m|
  m.id '17'
  m.ministry_role_id '5'    #student leader
  m.permission_id '8'
end

Factory.define :ministryrolepermission_18, :class => MinistryRolePermission do |m|
  m.id '18'
  m.ministry_role_id '5'    #student leader
  m.permission_id '11'
end

Factory.define :ministryrolepermission_19, :class => MinistryRolePermission do |m|
  m.id '19'
  m.ministry_role_id '5'    #student leader
  m.permission_id '7'
end

Factory.define :ministryrolepermission_20, :class => MinistryRolePermission do |m|
  m.id '20'
  m.ministry_role_id '5'
  m.permission_id '13'
end

Factory.define :ministryrolepermission_21, :class => MinistryRolePermission do |m|
  m.id '21'
  m.ministry_role_id '10'
  m.permission_id '13'
end

Factory.define :ministryrolepermission_22, :class => MinistryRolePermission do |m|
  m.id '22'
  m.ministry_role_id '5'
  m.permission_id '14'
end

Factory.define :ministryrolepermission_23, :class => MinistryRolePermission do |m|
  m.id '23'
  m.ministry_role_id '10'
  m.permission_id '14'
end

Factory.define :ministryrolepermission_2222, :class => MinistryRolePermission do |m|
  m.id '2222'				# formerly 22 (in 'remove_multiple_...' feature?)
  m.ministry_role_id '5'
  m.permission_id '14'
end

Factory.define :ministryrolepermission_2323, :class => MinistryRolePermission do |m|
  m.id '2323'				# formerly 23 (in 'remove_multiple_...' feature?)
  m.ministry_role_id '10'
  m.permission_id '14'
end

Factory.define :ministryrolepermission_24, :class => MinistryRolePermission do |m|
  m.id '24'
  m.ministry_role_id '10'
  m.permission_id '15'
end

Factory.define :ministryrolepermission_273, :class => MinistryRolePermission do |m|
  m.id '273'
  m.ministry_role_id '4'
  m.permission_id '273'
end

Factory.define :ministryrolepermission_274, :class => MinistryRolePermission do |m|
  m.id '274'
  m.ministry_role_id '4'
  m.permission_id '274'
end
