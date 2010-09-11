# Provides the following information:
# * Count of people in ministry
# * movement count (definition unclear)
# * names of newest people added
class DashboardController < ApplicationController
  include SemesterSet
  before_filter :set_current_and_next_semester

  def index
    @people_in_ministries = MinistryInvolvement.count(:conditions => ["#{_(:ministry_id, :ministry_involvement)} IN(?)", @ministry.id ])
    @movement_count = @my.ministry_involvements.length
  
    @ministry_ids ||= @my.ministry_involvements.collect(&:ministry_id).join(',')
    @group_stats = [ ]
      
    setup_stats

    if  @ministry_ids.present? #&& @ministry.campus_ids.present? 
       @newest_people = Person.find(:all, :conditions => "#{MinistryInvolvement.table_name}." + _(:ministry_id, :ministry_involvement) + " IN (#{@ministry_ids})", # OR #{CampusInvolvement.table_name}.#{_(:campus_id, :campus_involvement)} IN (#{@ministry.campus_ids.join(',')})
                                         :order => "#{Person.table_name}.#{_(:created_at, :person)} desc", :limit => 4, :joins => [:ministry_involvements, :campus_involvements])


      if Event.first.present?

        if @me.is_staff_somewhere?
          @my_campuses = get_ministry.unique_campuses
        else
          @my_campuses = @my.campuses
        end
        my_campuses_ids = @my_campuses.collect { |c| c.id }

        if my_campuses_ids.present? then
          my_event_ids = EventCampus.find(:all, :conditions => _(:campus_id, :event_campuses) + " IN (#{my_campuses_ids.join(',')})").collect { |ec| ec.event_id }
        end

        if my_event_ids.present? && @my_campuses.present? then

          my_events = Event.find(:all, :conditions => "#{Event.table_name}." + _(:id, :event) + " IN (#{my_event_ids.join(',')})")

          @eventbrite_events = []
          live_event_ids = [] # get only the event_ids for live events, right now we get the event status from Eventbrite

          @eventbrite_user = ::EventBright.setup_from_initializer()

          my_events.each do |event|
            eb_event = ::EventBright::Event.new(@eventbrite_user, {:id => event.eventbrite_id})

            if eb_event.status == eventbrite[:event_status_live] then
              if @my_campuses.size == 1 && event.campuses.size > 1 then
                attendees = event.all_attendees_from_campus(Campus.find(my_campuses_ids.first))
                eb_event.attributes[:my_campus_num_attendees] = attendees.size                
              end

              @eventbrite_events << eb_event
              live_event_ids << event.id

              if authorized?(:attendance, :events)
                eb_event.attributes[:link_to_report] = url_for(:controller => 'events', :action => 'attendance', :id => event.id)
              end
            end
          end

          if live_event_ids.present? then
            #find all event_groups that the live events are in
            event_group_ids = Event.find(:all, :conditions => "#{Event.table_name}." + _(:id, :event) + " IN (#{live_event_ids.join(',')})").collect { |e| e.event_group_id }
            @event_groups = EventGroup.find(:all, :conditions => "#{EventGroup.table_name}." + _(:id, :event_group) + " IN (#{event_group_ids.join(',')})")
          end
        end
      end
    end
  end

  protected

  def setup_stats
    ministry = get_ministry

    mis = MinistryInvolvement.find(:first, 
      :select => "count(distinct(#{MinistryInvolvement._(:person_id)})) as total", 
      :joins => "INNER JOIN #{Ministry.table_name} m ON #{MinistryInvolvement._(:ministry_id)} = m.id",
      :conditions => "lft >= #{ministry.lft} AND rgt <= #{ministry.rgt}")
    @num_people = mis.total

    sid = Semester.current.id
    gt_all = GroupType.find(:all, 
      :select => "#{GroupType.__(:id)} as id, #{GroupType.__(:group_type)} as name, count(*) as total",
      :joins => "INNER JOIN #{Group.table_name} g ON g.group_type_id = #{GroupType.table_name}.id INNER JOIN #{Ministry.table_name} m2 ON g.ministry_id = m2.id",
      :conditions => "m2.lft >= #{ministry.lft} AND m2.rgt <= #{ministry.rgt}",
      :group => "#{GroupType.__(:id)}")

    gt_sem = GroupType.find(:all, 
      :select => "#{GroupType.__(:id)} as id, #{GroupType.__(:group_type)} as name, count(*) as total",
      :joins => "INNER JOIN #{Group.table_name} g ON g.group_type_id = #{GroupType.table_name}.id INNER JOIN #{Ministry.table_name} m2 ON g.ministry_id = m2.id",
      :conditions => "m2.lft >= #{ministry.lft} AND m2.rgt <= #{ministry.rgt} AND g.semester_id = #{sid}",
      :group => "#{GroupType.__(:id)}")

    i = -1
    @group_stats = []
    GroupType.all.each do |gt|
      gt_all_total = gt_all.detect{ |gt_a| gt_a.name == gt.group_type }.try(:total) || 0
      gt_sem_total = gt_sem.detect{ |gt_s| gt_s.name == gt.group_type }.try(:total) || 0
      @group_stats << [ gt.group_type, gt_sem_total, gt_all_total ]
    end

    logins_week = Person.find(:first,
      :select => "count(distinct(#{Person.__(:id)})) as total",
      :joins => "INNER JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Person.__(:id)} INNER JOIN #{Ministry.table_name} m ON mi.ministry_id = m.id INNER JOIN #{Access.table_name} a ON a.person_id = #{Person.__(:id)} INNER JOIN #{User.table_name} v ON a.viewer_id = v.#{User._(:id)}",
      :conditions => ["m.lft >= #{ministry.lft} AND m.rgt <= #{ministry.rgt} AND #{User._(:last_login)} > ?", 1.week.ago])

    logins_month = Person.find(:first,
      :select => "count(distinct(#{Person.__(:id)})) as total",
      :joins => "INNER JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Person.__(:id)} INNER JOIN #{Ministry.table_name} m ON mi.ministry_id = m.id INNER JOIN #{Access.table_name} a ON a.person_id = #{Person.__(:id)} INNER JOIN #{User.table_name} v ON a.viewer_id = v.#{User._(:id)}",
      :conditions => ["m.lft >= #{ministry.lft} AND m.rgt <= #{ministry.rgt} AND #{User._(:last_login)} > ?", 1.month.ago ])

    @logins_this_week = logins_week.total
    @logins_this_month = logins_month.total

    timetables_week = Timetable.find(:first,
      :select => "count(distinct(#{Timetable.__(:person_id)})) as total",
      :joins => "INNER JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Timetable.__(:person_id)} INNER JOIN #{Ministry.table_name} m ON mi.ministry_id = m.id",
      :conditions => ["m.lft >= #{ministry.lft} AND m.rgt <= #{ministry.rgt} AND #{Timetable.__(:updated_at)} > ?", 1.week.ago])

    timetables_month = Timetable.find(:first,
      :select => "count(distinct(#{Timetable.__(:person_id)})) as total",
      :joins => "INNER JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Timetable.__(:person_id)} INNER JOIN #{Ministry.table_name} m ON mi.ministry_id = m.id",
      :conditions => ["m.lft >= #{ministry.lft} AND m.rgt <= #{ministry.rgt} AND #{Timetable.__(:updated_at)} > ?", 1.month.ago])

    @tt_last_week = timetables_week.total
    @tt_last_month = timetables_month.total
  end
end
