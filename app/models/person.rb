class Person < ActiveRecord::Base
  @@per_page = 500
  load_mappings
  acts_as_nested_set :parent_column => "person_mentor_id", :left_column => "person_mentees_lft",
    :right_column => "person_mentees_rgt", :id_column_name => _(:id)
  include Common::Core::Person
  include Common::Core::Ca::Person
  include Legacy::Stats::Core::Person
  include CiviCRM

  # Labels
  has_many :label_people, :class_name => "LabelPerson", :foreign_key => _(:person_id, :label_id)
  has_many :labels, :through => :label_people, :order => "#{Label.table_name}.#{_(:priority)} asc"

  # Training Questions
  has_many :training_answers, :class_name => "TrainingAnswer", :foreign_key => _(:person_id, :training_answer)
  has_many :training_questions, :through => :training_answers

  # Summer Projects
  has_many :summer_project_applications, :order =>  "#{SummerProjectApplication.table_name}.#{_(:created_at, :summer_project_application)}"
  has_many :summer_projects, :through => :summer_project_applications, :order => "#{SummerProject.table_name}.#{_(:created_at, :summer_project)} desc"

  # Custom Values
  has_many :custom_values, :class_name => "CustomValue", :foreign_key => _(:person_id, :custom_value)

    # Group Involvements
  # all
  has_many :all_group_involvements_assoc, :class_name => 'GroupInvolvement'
  has_many :all_groups, :through => :all_group_involvements_assoc,
    :source => :group
  # no interested or requests
  has_many :group_involvements_assoc,
    :class_name => 'GroupInvolvement',
    :conditions =>["#{_(:level, :group_involvement)} != ? AND " +
                   "(#{_(:requested, :group_involvement)} is null OR #{_(:requested, :group_involvement)} = ?)", 'interested', false]

  has_many :groups, :through => :group_involvements_assoc
  # interests
  has_many :group_involvement_interests_assoc,
    :class_name => 'GroupInvolvement',
    :conditions =>["#{_(:level, :group_involvement)} = ? AND " +
                   "(#{_(:requested, :group_involvement)} is null OR #{_(:requested, :group_involvement)} = ?)", 'interested', false]

  has_many :group_interests, :through => :group_involvement_interests_assoc,
    :class_name => 'Group', :source => :group
  # requests
  has_many :group_involvement_requests_assoc,
    :class_name => 'GroupInvolvement',
    :conditions => { _(:requested, :group_involvement) => true }
  has_many :group_requests, :through => :group_involvement_requests_assoc,
    :class_name => 'Group', :source => :group
  has_many :dismissed_notices

  has_one :mentor, :class_name => "Person", :primary_key => "person_mentor_id"
  has_many :mentees, :class_name => "Person", :foreign_key => "person_mentor_id"

  has_many :person_training_courses
  has_many :training_courses, :through => :person_training_courses
  has_many :finished_training_courses, :through => :person_training_courses,
    :source => :training_course,
    :conditions => ["#{PersonTrainingCourse._(:finished)} = 1"]

  has_many :contract_signatures

  has_many :survey_contacts
  has_and_belongs_to_many :discover_contacts, :join_table => ContactsPerson.table_name, :association_foreign_key => ContactsPerson._(:contact_id)
  has_and_belongs_to_many :contacts

  has_many :notes

  has_many :reported_activities, :foreign_key => :reporter_id

  has_one :recruitment
  has_many :recruiter_recruitment, :class_name => 'Recruitment', :foreign_key => :recruiter_id
  has_many :merges

  after_update :create_civicrm_contact


  def all_group_involvements(semester = nil)
    return self.all_group_involvements_assoc unless semester && semester.id

    ::GroupInvolvement.all(:joins => :group,
      :conditions => ["#{Person._(:id)} = ? AND #{Group._(:semester_id)} = ?",
                      self.id, semester.id])
  end

  def group_involvements(semester = nil)
    return self.group_involvements_assoc unless semester && semester.id

    ::GroupInvolvement.all(:joins => :group,
      :conditions => ["#{Person._(:id)} = ? AND #{Group._(:semester_id)} = ? AND " +
                      "#{_(:level, :group_involvement)} != ? AND " +
                      "(#{_(:requested, :group_involvement)} is null OR #{_(:requested, :group_involvement)} = ?)",
                      self.id, semester.id, 'interested', false])
  end

  def group_involvement_interests(semester = nil)
    return self.group_involvement_interests_assoc unless semester && semester.id

    ::GroupInvolvement.all(:joins => :group,
      :conditions => ["#{Person._(:id)} = ? AND #{Group._(:semester_id)} = ? AND " +
                      "#{_(:level, :group_involvement)} = ? AND " +
                      "(#{_(:requested, :group_involvement)} is null OR #{_(:requested, :group_involvement)} = ?)",
                      self.id, semester.id, 'interested', false])
  end

  def group_involvement_requests(semester = nil)
    return self.group_involvement_requests_assoc unless semester && semester.id

    ::GroupInvolvement.all(:joins => :group,
      :conditions => ["#{Person._(:id)} = ? AND #{Group._(:semester_id)} = ? AND " +
                      "#{_(:requested, :group_involvement)} = ?",
                      self.id, semester.id, true])
  end

  def most_recent_group_involvement
    self.group_involvements.all(:first, :conditions => ["#{Person._(:id)} = ?", self.id], :order => "created_at desc").first
  end

  def custom_value_hash
    if @custom_value_hash.nil?
      @custom_value_hash = {}
      custom_values.each {|cv| @custom_value_hash[cv.custom_attribute_id] = cv.value }
    end
    @custom_value_hash
  end

  def training_answer_hash
    if @training_answer_hash.nil?
      @training_answer_hash = {}
      training_answers.each {|ta| @training_answer_hash[ta.training_question_id] = ta }
    end
  end

  # genderization for personafication in templates
  alias_method :get_custom_value_hash, :custom_value_hash
  alias_method :get_training_answer_hash, :training_answer_hash

  # Get the value of a custom_attribute
  def get_value(attribute_id)
    get_custom_value_hash
    return @custom_value_hash[attribute_id]
  end

  def get_training_answer(question_id)
    get_training_answer_hash
    return @training_answer_hash[question_id]
  end

  def group_group_involvements(filter, options = {})
    case filter
    when :all
      gis = all_group_involvements(options[:semester])
    when :involved
      gis = group_involvements(options[:semester])
    when :interests
      gis = group_involvement_interests(options[:semester])
    when :requests
      gis = group_involvement_requests(options[:semester])
    end
    if options[:ministry]
      gis.delete_if{ |gi|
        gi.group.ministry != options[:ministry]
      }
    end
    gis.group_by { |gi| gi.group.group_type }
  end

  def is_leading_group_with?(p)
    !group_involvements.find_all_by_level(%w(leader co-leader)).detect{ |gi|
      gi.group.people.detect{ |gp| gp == p }
    }.nil?
  end

  def is_leading_mentor_priority_group_with?(p)
    !group_involvements.find_all_by_level(%w(leader co-leader)).detect{ |gi|
      gi.group.group_type.mentor_priority && gi.group.people.detect{ |gp| gp == p }
    }.nil?
  end

  # Initialize the value of a custom_attribute
  def create_value(attribute_id, value)
    get_custom_value_hash
    sql = "INSERT INTO    #{CustomValue.table_name} (#{::Person::_(:person_id, :custom_value)}, #{::Person::_(:custom_attribute_id, :custom_value)},
                                                    #{::Person::_(:value, :custom_value)})
                  VALUES  (#{id}, #{attribute_id}, '#{quote_string(value)}')"
    CustomValue.connection.execute(sql)
    @custom_value_hash[attribute_id] = value
  end

  # Set the value of a custom_attribute
  def set_value(attribute_id, value)
    get_custom_value_hash
    if @custom_value_hash[attribute_id].nil?
      create_value(attribute_id, value)
    else
      if value && @custom_value_hash[attribute_id] != value
        sql = "UPDATE #{CustomValue.table_name} SET   #{::Person::_(:value, :custom_value)} = '#{quote_string(value)}'
                                                WHERE #{::Person::_(:person_id, :custom_value)} = #{id}
                                                AND   #{::Person::_(:custom_attribute_id, :custom_value)} = #{attribute_id}"
        CustomValue.connection.execute(sql)
        @custom_value_hash[attribute_id] = value
      end
    end
    value
  end

  # Set the value of a training_answer
  def set_training_answer(question_id, date, approver)
    get_training_answer_hash
    date = nil if date == ''
    if @training_answer_hash[question_id].nil? && date
      # Create a row for this answer
      answer = TrainingAnswer.create(_(:person_id, :training_answer) => id, _(:training_question_id, :training_answer) => question_id,
                                      _(:completed_at, :training_answer) => date, _(:approved_by, :training_answer) => approver)
      @training_answer_hash[question_id] = answer
    elsif date
      approved_by = approver ? approver : @training_answer_hash[question_id].approved_by
      @training_answer_hash[question_id].update_attributes({_(:completed_at, :training_answer) => date, _(:approved_by, :training_answer) => approver})
    end
  end

  def is_global_dashboard_admin
    v = self.try(:user).try(:global_dashboard_access).try(:admin)
  end

  def has_mentor?
    attr = "person_mentor_id"
    return !(self.send(attr).nil?)
  end

  def signed_volunteer_contract_this_year?
    return false if self.find_next_unsigned_volunteer_contract.present?
    true
  end

  def find_next_unsigned_volunteer_contract
    # we want to allow signing the contracts one month before the year technically begins

    if Month.current == Year.current.months.last
      year = Year.first(:conditions => {:year_number => Year.current.year_number+1}) || Year.current
    else
      year = Year.current
    end

    contract = nil

    Contract::VOLUNTEER_CONTRACT_IDS.each do |contract_id|
      next if ContractSignature.all(:conditions => ["#{ContractSignature._(:person_id)} = ? and
                                                     #{ContractSignature._(:contract_id)} = ? and
                                                     #{ContractSignature._(:agreement)} = true and
                                                     #{ContractSignature._(:signature)} <> '' and
                                                     #{ContractSignature._(:signed_at)} > ?",
                                                     self.id, contract_id, year.start_date-1.month]).present?
      contract = Contract.find(:first, :conditions => { :id => contract_id })
      break
    end

    contract
  end

  def recruitable?
    self.labels.all(:conditions => { :id => Recruitment::QUALIFIED_FOR_RECRUITMENT_LABEL_ID }).present?
  end

  def set_label(label)
    if labels.include?(label)
      false
    else
      labels << label
    end
  end

  def remove_label_with_id(label_id)
    label_record = LabelPerson.find_by_label_id_and_person_id(label_id, self.id)
    if label_record
      label_record.destroy
      label_record.save
    else
      nil
    end
  end

  def self.setup_merge_testers
    return [ setup_merge_tester(1), setup_merge_tester(2) ]
  end

  def self.setup_merge_tester(id)
    p = Person.find_or_create_by_person_email "testmerge#{id}@tester.com", 
      :person_fname => "merge#{id}_fname", 
      :person_lname => "merge#{id}_lname", 
      :person_legal_fname => "merge#{id}_legal_fname",
      :person_legal_lname => "merge#{id}_legal_lname"
    p.user.destroy if p.user.present?
    p.access.destroy if p.access.present?
    u = User.find_by_viewer_userID("testmerge#{id}@tester.com")
    u.destroy if u
    p.create_user_and_access_only("testmerge#{id}", "testmerge#{id}@tester.com")
    return p
  end

  private
  def create_civicrm_contact
    return unless self.email.present? && self.first_name.present? && self.last_name.present? && self.civicrm_id.blank?
    connect = CiviCRM::API.new
    params = { :first_name => self.first_name, :last_name => self.last_name, 
      :contact_type => "Individual", :"api.email.create[email]" => self.email }
    params[:id] = self.civicrm_id if self.civicrm_id.present?
    contact = connect.create(:Contact, :with => params)
    if contact.present? && contact.first.respond_to?(:id)
      self.update_attribute(:civicrm_id, contact.first.id)
    end 
  end
end
