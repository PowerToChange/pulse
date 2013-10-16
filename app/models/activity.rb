class Activity < ActiveRecord::Base
  include CiviCRM
  TYPES = [[nil, 0], ['Interaction', 1], ['Spiritual Conversation', 2], ['Gospel Presentation', 3], ['Indicated Decision', 4], ['Shared Spirit-filled life', 5]]

  belongs_to :reporter, :class_name => 'Person', :foreign_key => :reporter_id
  belongs_to :reportable, :polymorphic => true

  validates_presence_of :reporter_id
  validates_presence_of :activity_type_id
  validates_presence_of :reportable_type
  validates_presence_of :reportable_id

  after_create :create_stats

  def self.rejoiceable_types
    TYPES[2..5]
  end

  def to_s
    activity_type_id && TYPES[activity_type_id] ? TYPES[activity_type_id][0] : ''
  end

  def person
    reporter.is_a?(Person) ? reporter : nil
  end

  private

  def create_stats
    case self.activity_type_id
    when 4 # Indicated Decision

      notes = case self.reportable.class.to_s
      when "SurveyContact"
        "Imported from September Launch Follow-up"
      when "DiscoverContact"
        "Imported from Discover Contact Tracking"
      else
        ""
      end

      method_id = case self.reportable.class.to_s
      when "SurveyContact"
        10 # SIQ Follow-up
      when "DiscoverContact"
        4 # Friendship Evangelism
      else
        12 # Other
      end
        
      civicrm_infos = {
        :contact_info => {
          :contact_type => 'Individual',
          :first_name => self.reportable.first_name
        },
        :school_info => {
          :external_identifier => self.reportable.campus_id
        }
      }
      
      connect = CiviCRM::API.new

      newcontact = connect.create(:Contact, :with => civicrm_infos[:contact_info])
      school = connect.get(:Contact, :with => civicrm_infos[:school_info])
  
      rejoiceable_info = {
          :source_contact_id => self.reporter.civicrm_id,
          :target_contact_id => newcontact[0].id,
          :assignee_contact_id => school[0].id,
          :activity_type_id => 47, #Rejoiceable
          :subject => 'Indicated Decision',
          :status_id => 2,  # Completed
          :activity_date_time => self.created_at.to_date, # MAKE SURE THIS IS YYYY-MM-DD
          :engagement_level => 0, # ??
          :custom_143 => '4', #Indicated Decision
          :custom_163 => '2',  #Friendship Evangelism
          :custom_171 => self.reporter.full_name,
          :details => 'Imported from Discover Contact Tracking'
        }

      rejoiceable = connect.create(:Activity, :with => rejoiceable_info)
    end
  end
end
