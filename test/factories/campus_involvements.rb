
Factory.define :campusinvolvement, :class => CampusInvolvement do |c|
  c.sequence(:id) {|n| n }
  c.sequence(:person_id) {|n| n }
  c.campus_id '1'
  c.ministry_id '1'
  c.school_year_id '1'
end


Factory.define :campusinvolvement_2, :class => CampusInvolvement do |c|
  c.id '1002'
  c.person_id '2000'
  c.campus_id '1'
  c.ministry_id '1'
  c.start_date '2009-10-10'
  c.school_year_id '1'
end

Factory.define :campusinvolvement_3, :class => CampusInvolvement do |c|
  c.id '1003'
  c.person_id '50000'
  c.campus_id '1'
  c.ministry_id '1'
  c.school_year_id '1'
end

Factory.define :campusinvolvement_4, :class => CampusInvolvement do |c|
  c.id '1004'
  c.person_id '2000'
  c.campus_id '2'
  c.ministry_id '1'
  c.school_year_id '1'
  c.start_date '2009-10-20'
end

Factory.define :campusinvolvement_5, :class => CampusInvolvement do |c|
  c.id '1005'
  c.person_id '4001'
  c.campus_id '1'
  c.ministry_id '1'
  c.school_year_id '1'
end

Factory.define :campusinvolvement_6, :class => CampusInvolvement do |c|
  c.id '1006'
  c.person_id '3000'
  c.campus_id '1'
  c.ministry_id '1'
  c.school_year_id '1'
end
