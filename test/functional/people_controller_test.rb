require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'


# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < ActionController::TestCase
  def setup
    setup_years
    setup_months
  end
  
  def login_admin_user
    Factory(:user_1)
    Factory(:access_1)
    Factory(:person_1)
    Factory(:ministry_1)
    Factory(:ministryrole_1)
    Factory(:ministryinvolvement_1)
    Factory(:campus_1)
    Factory(:campusinvolvement_setperson, :person_id => "50000")
    
    login('josh.starcher@example.com')
  end
  
  def barebones_login_admin_user
    Factory(:user_1)
    Factory(:access_1)
    Factory(:person_1)
    Factory(:ministry_1)
    Factory(:ministryrole_1)
    
    login('josh.starcher@example.com')
  end
    
  def setup_mentorship
    
    #Person 6
    Factory(:person_6)
    Factory(:ministry_1)
    Factory(:ministryrole_3)
    Factory(:campus_1)
    Factory(:campusinvolvement_5)
    Factory(:ministryinvolvement_8)
    Factory(:profilepicture_6)
    
    #Person 3
    Factory(:person_3)
    Factory(:ministryrole_6)
    Factory(:campusinvolvement_4) 
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:ministryinvolvement_9)
    Factory(:profilepicture_30)
    
    #Person 2
    Factory(:person_2)
    Factory(:ministryrole_6)
    Factory(:campusinvolvement_6) 
    Factory(:ministry_1)
    Factory(:campus_1)
    Factory(:ministryinvolvement_10)   
    Factory(:profilepicture_20)
  end

  def test_update
    login_admin_user
    xhr :get, :update,
        :id => 50000,
        :user => { :guid => "test" },
        :person => { :middle_name => "new middle name" },
        :primary_campus_involvement => { :start_date => '2010-03-31' }       

    assert_equal("test", ::User.all(:conditions => {User._(:id) => 1}).first.guid)
    assert_equal("new middle name", ::Person.all(:conditions => {Person._(:id) => 50000}).first.middle_name)
    assert_equal("03/31/2010", ::CampusInvolvement.all(:conditions => {:id => 1}).first.start_date.to_s)
  end

  def test_set_current_address_states
    Factory(:country_1)
    Factory(:country_2)
    Factory(:state_1)
    Factory(:state_2)
    login_admin_user
    xhr :get, :set_current_address_states, :current_address_country => 'USA'
    assert_not_nil(assigns["current_address_states"])
    assert_equal(2, assigns["current_address_states"].size)
  end

  def test_set_permanent_address_states
    Factory(:country_1)
    Factory(:country_2)
    Factory(:state_1)
    Factory(:state_2)
    login_admin_user
    xhr :get, :set_permanent_address_states, :perm_address_country => 'USA'
    assert_not_nil(assigns["permanent_address_states"])
    assert_equal(2, assigns["permanent_address_states"].size)
  end

  def test_get_campus_states
    Factory(:country_1)
    Factory(:country_2)
    Factory(:state_1)
    Factory(:state_2)
    login_admin_user
    setup_campuses
    xhr :get, :get_campus_states, :primary_campus_country => 'USA'
    assert_not_nil(assigns["campus_states"])
    assert_equal(2, assigns["campus_states"].size)
  end

  def test_me
    login_admin_user
    xhr :get, :me
    assert_not_nil(assigns["person"])
    assert_equal(50000, assigns["person"].id)
  end

  def test_get_campuses_for_state
    login_admin_user
    setup_campuses

    xhr :get, :get_campuses_for_state, :primary_campus_state => 'CA', :primary_campus_country => 'US'

    assigns["campuses"].each do |campus|
      assert_equal("CA", campus.state.abbrev)
    end
  end

  def test_set_initial_campus
    barebones_login_admin_user
    Factory(:ministry_1)
    Factory(:campus_1)
    Factory(:schoolyear_1)
    xhr :put, :set_initial_campus, :person => { :school_year => ["1"], :gender => ["1"], :first_name => "Josh", 
      :local_phone => "123-456-7890", :last_name => "Starcher", :email => "josh.starcher@uscm.org" },
      :primary_campus_involvement => { :campus_id => 1, :school_year_id => 1 }
    assert_not_nil(assigns["primary_campus_involvement"])
    assert_equal(50000, assigns["primary_campus_involvement"].person_id)
    assert_equal(1, assigns["primary_campus_involvement"].campus_id)
  end

  def test_directory
    login_admin_user
    Factory(:search_1)
    Factory(:column_5)
    @ministry = Ministry.find(1)
    @ministry.views.first.columns << Column.find(5)
    get :directory, :search_id => 1

    assert_response :success
    assert_equal(50000, assigns["people"][0]["person_id"].to_i)
    assert_equal(1, assigns["people"].size)

    #Factory(:address_1)
    get :directory, :school_year => ["1"], :gender => ["1"], :first_name => "Josh", :last_name => "Starcher", :email => "josh.starcher@uscm.org"
    assert_response :success
    #assert_equal("50000", assigns["people"][0]["person_id"])
  end

=begin
# test is broken - setup_n_ministry_involvements was never implemented by SD, or
# removed. -AR
  def test_directory_too_many_search_results
    setup_n_people(2000)
    setup_n_ministry_involvements(2000)
    get :directory
    assert_response :success
    assert_not_nil(assigns["people"])
  end
=end

# test written by SD but failing, so disabled -AR
=begin
  def test_directory_ministry_and_campus
    setup_people
    setup_ministry_involvements
    setup_campus_involvements

    get :directory, :ministry => [1]
    assert_not_nil(assigns["people"])
    assert_equal(2, assigns["people"].size)

    get :directory, :campus => [1]
    assert_not_nil(assigns["people"])
    assert_equal(3, assigns["people"].size)
  end
=end

  test "full directory" do
    login_admin_user
    get :directory, :force => 'true'
    assert_response :success
    assert assigns(:people)
    assert_template('directory')
  end
  
  # def test_directory_download
  #   @request.env["HTTP_ACCEPT"] = "text/html"
  #   get :directory, :format => :xls
  #   assert_equal "text/html", @response.content_type
  #   assert_response 406
  #   assert assigns(:people)
  # end
  
  test "when i do a search, save it" do
    login_admin_user
    assert_difference "Search.count" do
      post :directory, :search => 'all'
    end
  end
  
  test "directory pagination" do
    login_admin_user
    post :directory, :search => 'all'
    assert_response :success
    assert assigns(:people)
  end

  
  def test_ministry_leader_show_own_mentorship
    Factory(:user_5)
    Factory(:access_5)
    Factory(:person_6)
    Factory(:ministry_1)
    Factory(:ministryrole_3)
    Factory(:campus_1)
    Factory(:campusinvolvement_5)
    Factory(:ministryinvolvement_8)
    Factory(:permission_11)  # show_mentor    
    Factory(:ministryrolepermission_11)
    Factory(:permission_12)  # show_mentees  
    Factory(:ministryrolepermission_12)
    
    login('min_leader_with_no_permanent_address')
    
    get :show, :id => Factory(:person_6).id   # navigate to own profile

    assert_template :show
    assert_template :partial => '_mentors', :count => 1
    assert_template :partial => '_mentees', :count => 1
  end  
  
  def test_student_show_own_mentorship
    Factory(:user_3)
    Factory(:access_3)
    Factory(:person_3)
    Factory(:ministryrole_6)
    Factory(:campusinvolvement_4) 
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:ministryinvolvement_9)
    Factory(:permission_11)  # show_mentor    
    Factory(:ministryrolepermission_13)
    
    login('sue@student.org')
    
    get :show, :id => Factory(:person_3).id   # navigate to own profile
    
    assert_template :show
   # puts @response.body
    assert_template :partial => '_mentors', :count => 1
    assert_template :partial => '_mentees', :count => 0
  end    
  
  
  def test_student_remove_own_mentor
    Factory(:person_6)  # mentor
    Factory(:user_2)
    Factory(:access_2)
    Factory(:person_2)
    Factory(:ministryrole_6)
    Factory(:campusinvolvement_6) 
    Factory(:ministry_1)
    Factory(:campus_1)
    Factory(:ministryinvolvement_10)
    Factory(:permission_11)  # show_mentor  
    Factory(:permission_9)  # remove_mentor  
    Factory(:ministryrolepermission_13)
    Factory(:ministryrolepermission_14)   
    
    login('fred@uscm.org')
    
    get :show, :id => Factory(:person_2).id   # navigate to own profile
    
    assert_template :show
    assert_template :partial => '_mentors', :count => 1
    
    assert_equal Factory(:person_6).id, @person.person_mentor_id  # ensure mentor relation

    xhr :get, :remove_mentor, :id => @person.id
    # use Person.find because @person doesn't change due to scope
    assert_nil Person.find(@person.id).person_mentor_id
  end    
  
  def test_ministry_leader_remove_own_mentee
    Factory(:person_6)    #4001 -- the mentee's mentor, so needs to be done first
    Factory(:person_2)    #mentee
    Factory(:user_5)
    Factory(:access_5)

    Factory(:ministry_1)
    Factory(:ministryrole_3)
    Factory(:campus_1)
    Factory(:campusinvolvement_5)
    Factory(:ministryinvolvement_8)
    Factory(:permission_12)  # show_mentees  
    Factory(:ministryrolepermission_12)
    Factory(:permission_10)  # remove_mentee 
    Factory(:ministryrolepermission_15)   
    
    login('min_leader_with_no_permanent_address')
    
    get :show, :id => Factory(:person_6).id # show own profile

    assert_template :show
    assert_template :partial => '_mentees', :count => 1
    
    assert_equal @person.id, Factory(:person_2).person_mentor_id  # ensure person 2 is mentee
    
    xhr :get, :remove_mentee, :id => Factory(:person_2).id

    # use Person.find because @person doesn't change due to scope
    assert_nil Person.find(Factory(:person_2).id).person_mentor_id
  end      
  
  def test_student_leader_add_own_mentee
    Factory(:person_3)    #mentee
    Factory(:user_1)
    Factory(:access_1)
    Factory(:person_1)
    Factory(:ministry_1)
    Factory(:ministryrole_4) #id 5
    Factory(:campus_1)
    Factory(:campusinvolvement_3)
    Factory(:ministryinvolvement_11)
    Factory(:permission_12)  # show_mentees  
    Factory(:ministryrolepermission_16)
    Factory(:permission_8)  # add_mentee 
    Factory(:ministryrolepermission_17)   
    
    login('josh.starcher@example.com')
    
    get :show, :id => Factory(:person_1).id # show own profile

    assert_template :show
    assert_template :partial => '_mentees', :count => 1
    
    assert_not_equal @person.id, Factory(:person_3).person_mentor_id  # ensure person 3 is NOT mentee
    
    xhr :get, :show, :id => Factory(:person_1).id, :mt => Factory(:person_3).id

    # use Person.find because @person doesn't change due to scope
    assert_equal @person.id, Person.find(Factory(:person_3).id).person_mentor_id  
  end  
  
  def test_student_leader_add_own_mentor
    Factory(:person_6)    #mentor
    Factory(:user_1)
    Factory(:access_1)
    Factory(:person_1)
    Factory(:ministry_1)
    Factory(:ministryrole_4)
    Factory(:campus_1)
    Factory(:campusinvolvement_3)
    Factory(:ministryinvolvement_11)
    Factory(:permission_11)  # show_mentor  
    Factory(:ministryrolepermission_18)
     Factory(:permission_7)  # add_mentor 
    Factory(:ministryrolepermission_19)   
    
    login('josh.starcher@example.com')
    
    get :show, :id => Factory(:person_1).id # show own profile

    assert_template :show
    assert_template :partial => '_mentors', :count => 1
    
    assert_not_equal Factory(:person_6).id, @person.person_mentor_id  # ensure person 6 is NOT mentor
    xhr :get, :show, :id => Factory(:person_1).id, :m => Factory(:person_6).id

    # use Person.find because @person doesn't change due to scope
    assert_equal Factory(:person_6).id, Person.find(Factory(:person_1).id).person_mentor_id  
  end        
  
  test "A person with no campus involvements should still show in the directory" do
    Factory(:user_6)
    Factory(:access_6)
    Factory(:person_7)
    Factory(:ministryrole_9)
    Factory(:ministryinvolvement_6)
    Factory(:ministryrolepermission_5)
    Factory(:permission_4)
    Factory(:permission_15) # advanced search
    Factory(:ministryrolepermission_24) # advanced search
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:ministrycampus_4)
    Ministry.rebuild!

    login('staff_on_ministry_with_no_campus')
    get :directory, :force => 'true'
    assert_response :success, @response.body
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_7).id}, "staff_on_ministry_with_no_campus didn't show up.")
  end
  
  test "perform search by firstname" do
    login_admin_user
    post :directory, :search => 'josh'
    assert_response :success
    assert assigns(:people)
  end
  
  test "perform search by fullname" do
    login_admin_user
    post :directory, :search => 'josh starcher'
    assert_response :success
    assert assigns(:people)
  end
  
  test "perform search by email" do
    login_admin_user
    post :directory, :search => 'josh.starcher@uscm.org'
    assert_response :success
    assert assigns(:people)
  end
  
=begin
  test "directory paginate Z" do
    login_admin_user
    post :directory, :first => 'Z', :finish => ''
    assert_response :success
    assert assigns(:people)
  end
=end

=begin
# test is broken - setup_n_ministry_involvements was never implemented by SD, or
# removed. -AR
  test "search filter ids" do
    setup_n_people(5)
    setup_n_ministry_involvements(5)

    xhr :post, :search, :search => 'A', :filter_ids => [1,2,3], :context => 'group_involvements'
    
    assert_response :success
    assert_not_nil(assigns["people"])
    assert_equal(4, assigns["people"][0].id)
    assert_equal(5, assigns["people"][1].id)
  end
=end
  
  test "search full name" do
    login_admin_user
    xhr :post, :search, :search => 'Josh Starcher', :context => 'group_involvements', :group_id => 2, :type => 'leader'
    assert_response :success
  end
  
  test "search first name" do
    login_admin_user
    xhr :post, :search, :search => 'Josh', :context => 'group_involvements', :group_id => 2, :type => 'leader'
    assert_response :success
  end
  
  test "search with no results" do
    login_admin_user
    get :search, :search => 'xyz', :context => 'group_involvements'
    assert_response :success
  end

  test "should get new" do
    login_admin_user
    get :new
    assert_response :success
  end
  
  test "should change view" do
    login_admin_user
    post :change_view, :view => '1'
    assert_redirected_to directory_people_path(:format => :html)
  end
  
  test "should have all campuses on directory for staff" do
    login_admin_user
    get :directory
    assert_array_similarity(Ministry.first.campuses + Ministry.first.children.collect(&:campuses).flatten, assigns(:campuses))
  end

  test "should clear session order when changing view" do
    login_admin_user
    get :directory, :order => Person._(:first_name)
    post :change_view, :view => '1'
    assert_redirected_to directory_people_path(:format => :html)
    assert_nil session[:order]
  end
  
  test "should re-create staff" do
    login_admin_user
    #Factory(:address_1)
    Factory(:accessgroup_1)
    old_count = Person.count
    post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
                  :current_address => {:email => "josh.starcher@example.com"},
                  :ministry_involvement => { :ministry_role_id => StaffRole.first.id },
                  :campus_involvement => { :campus_id => 1, :school_year_id => 1 }
    assert_equal old_count, Person.count
    assert_redirected_to person_path(assigns(:person))
  end
  
  test "should create student" do
    login_admin_user
    Factory(:accessgroup_1)
    Factory(:ministryrole_6)
    assert_difference "Person.count" do
      post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => '1' }, 
                    :current_address => {:email => "josh.starcher@gmail.org"}, 
                    :modalbox => 'true', 
                    :ministry_involvement => { :ministry_id => 1, :ministry_role_id => StudentRole.first.id }, 
                    :campus_involvement => { :campus_id => 1, :school_year_id => 1 }
      assert person = assigns(:person)
      assert_not_nil person.user.id
      assert_redirected_to person_path(assigns(:person))
    end
  end
  
  # def test_should_create_student_with_username_conflict # Not likely to ever happen
  #   old_count = Person.count
  #   test_should_create_student
  #   post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
  #                 :current_address => {:email => "josh.starcher@gmail.org"}, :student => true
  #   assert person = assigns(:person)
  #   assert_equal old_count+1, Person.count
  #   assert_redirected_to person_path(assigns(:person))
  # end
  
  test "should re-create student" do
    login_admin_user
    #Factory(:address_1)
    Factory(:accessgroup_1)
    Factory(:ministryrole_6)
    assert_no_difference('Person.count') do
      post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
                    :current_address => {:email => "josh.starcher@example.com"},
                    :ministry_involvement => { :ministry_role_id => StudentRole.first.id },
                    :campus_involvement => { :campus_id => 1, :school_year_id => 1 }
      assert person = assigns(:person)
    end
    assert_redirected_to person_path(assigns(:person))
  end
  
  test "should NOT create person" do
    login_admin_user
    assert_no_difference('Person.count') do
      post :create, :person => { }, :ministry_involvement => { :ministry_role_id => StaffRole.first.id }
    end
    assert_response :success
    assert_template 'new'
  end
  
  test "should_show_person" do
    login_admin_user
    get :show, :id => Factory(:person_1).id
    
    assert_template :show
    assert_template :partial => '_view', :count => 1
    assert_response :success
  end
  
  test "should_show_rp" do
    login_admin_user
    get :show, :id => Factory(:person_3).id
    
    assert_template :show
    assert_template :partial => '_view', :count => 1
    assert_response :success
  end
  
  test "should_get_edit" do
    login_admin_user
    get :edit, :id => 50000
    assert_response :success
  end
  
  test "should_get_edit_for_someone_in_my_group" do
    Factory(:user_3)
    Factory(:person_3)
    Factory(:access_3)
    Factory(:ministryrole_3)
    Factory(:ministryinvolvement_4)
    Factory(:ministry_1)
    Factory(:campus_1)
    Factory(:campus_2)
    Factory(:campusinvolvement_2)
    Factory(:campusinvolvement_4)
    setup_groups
    login('sue@student.org') # leading group 3; sue is a student ministry leader
    get :edit, :id => 50 # member in group 3
    assert_response :success
  end

  test "should_show_possible_responsible_people" do
    login_admin_user
    if Cmt::CONFIG[:rp_system_enabled]
      Factory(:person_3)
      get :edit, :id => 2000
      assert_response :success
      assert_not_nil assigns(:possible_responsible_people)
    else
      assert true
    end
  end
  
  test "should update person" do
    login_admin_user
    Factory(:person_6) # required as mentor for person #2
    Factory(:person_2)
    xhr :put, :update, :id => 50000, :person => {:first_name => 'josh', :last_name => 'starcher' }, 
                       :current_address => {:email => "josh.starcher@uscm.org"}, 
                       :perm_address => {:phone => '555-555-5555', :address1 => 'here'},
                       :primary_campus_id => 1, :primary_campus_involvement => {},
                       :responsible_person_id => Factory(:person_2).id
    assert_template '_view'
  end
  
  test "should NOT update person" do
    login_admin_user
    xhr :put, :update, :id => 50000, :person => {:first_name => '' }
    assert_response :success
    assert_template '_edit'
  end
  
  test "should end a person's involvements" do
    login_admin_user
    @request.env["HTTP_REFERER"] = directory_people_path
    delete :destroy, :id => Factory(:person_3).id
    assert person = assigns(:person)
    assert(!person.ministry_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a ministry involvement without an end date")
    assert(!person.campus_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a campus involvement without an end date")
    assert_redirected_to directory_people_path
  end
  
  test "should end a person's campus involvements with no ministry involvements" do
    login_admin_user
    @request.env["HTTP_REFERER"] = directory_people_path
    reset_people_sequences
    Factory(:person)
    delete :destroy, :id => 1
    assert person = assigns(:person)
    assert(!person.campus_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a campus involvement without an end date")
    assert_redirected_to directory_people_path
  end
  
  test "change ministry and goto directory" do
    login_admin_user
    xhr :post, :change_ministry_and_goto_directory, :current_ministry => '1'
    assert_response :success
  end
  
  test "change to a ministry that is under my assigned level" do
    Factory(:ministry_1)
    Factory(:ministry_2)
    login_admin_user
    xhr :post, :change_ministry_and_goto_directory, :current_ministry => Factory(:ministry_3).id
    assert_response :success
    assert_equal(3, session[:ministry_id])
    
    get :directory
    assert_equal(Factory(:ministry_3), assigns(:ministry))
  end
  
  test "change to a ministry that is NOT under my assigned level should default to my first ministry for student" do
    Factory(:user_5)
    Factory(:access_5)
    Factory(:person_6)
    Factory(:ministryrole_3)
    Factory(:ministryinvolvement_5)
    Factory(:ministry_4)
    Factory(:ministry_5)
    Factory(:campusinvolvement_5)
    Factory(:campus_1)
    login 'min_leader_with_no_permanent_address'
    get :change_ministry_and_goto_directory, :current_ministry => Factory(:ministry_4).id
    assert_response :redirect
    assert_not_equal(Factory(:ministry_4), assigns(:ministry))
    assert_equal(Factory(:person_6).ministries.first, assigns(:ministry))
  end

  test "change to a ministry that is NOT under my assigned level should still work for staff" do
    login_admin_user
    get :change_ministry_and_goto_directory, :current_ministry => Factory(:ministry_4).id
    assert_response :redirect
    assert_equal(Factory(:ministry_4), assigns(:ministry))
  end
 
  
  test "user with no ministry involvements should be redirected to set their initial campus" do
    Factory(:ministry_1)
    Factory(:user_4)
    Factory(:person_5)
    Factory(:access_4)
    login('user_with_no_ministry_involvements')
  
    get :directory
  
    assert_redirected_to "http://test.host/people/4000/set_initial_campus"
  end
  
  test "ministry leader with no permanent address should render when updating notes" do
    login_admin_user
  
    # setup session
    Factory(:ministry_4)
    ministry = Factory(:ministry_5)

    Factory(:access_5)
    user = Factory(:user_5)
    @request.session[:user] = user.id
    @request.session[:ministry_id] = ministry.id
    
    person = Factory(:person_6)
    Factory(:ministryrole_3)
    Factory(:ministryinvolvement_5)
    Factory(:campusinvolvement_5)
    Factory(:campus_1)
  
    # make sure it renders properly
    get :show, :id => person.id
    assert_response :success
  
    # save the staff notes    
    xhr :post, :update,
      :staff_notes => 'A Note',
      :id => person.id
    
    # make sure everything renders properly
    assert_response :success
    assert_template :partial => '_view', :count => 1    
  end

  test "show group involvements per semester" do
    login_admin_user
    person = Factory(:person_1)
    Factory(:campus_2)
    Factory(:grouptype_1)
    Factory(:group_3)
    Factory(:groupinvolvement_7)
    Factory(:semester_414)

    post :show_group_involvements, :id => person.id, :semester_id => 14

    assert_equal 14, assigns(:semester).id

    # actual group involvements are fetched in the js view...
  end
 
  test "should show discipleship tree" do
    login_admin_user
 
    # setup mentorship
    person1 = Factory(:person_mentor)
    person2 = Factory(:person_mentor)
    person3 = Factory(:person_mentor)
    
    person3.person_mentor_id = person2.id
    person3.save!
    person2.person_mentor_id = person1.id
    person2.save!

    get :discipleship, :id => person1.id
    
    assert_response :success   
 
     # test to see that default summary is shown (i.e. for the person at root of tree)    
     xhr :get, :show_mentee_summary,
      :mentee_id => person1.id
       
     assert_template :partial => '_mentee_summary', :count => 1
     assert_response :success   
  end
  
  test "should show invalid access page for mentee summary" do
    # log in as student leader with proper permissions
#    Factory(:user_1)
#    Factory(:access_1)
#    Factory(:person_1)
#    Factory(:ministry_1)
#    Factory(:ministryrole_4) #id 5
#    Factory(:campus_1)
#    Factory(:campusinvolvement_3)
#    Factory(:ministryinvolvement_11)
#    Factory(:permission_273)  # show discipleship tree  
#    Factory(:ministryrolepermission_273)
#    Factory(:permission_274)  # show mentee summary info (if within campus scope)
#    Factory(:ministryrolepermission_274)   
#    
#    login('josh.starcher@example.com')
# 
#    # setup mentorship
#    person1 = Factory(:person_mentor)
#    person2 = Factory(:person_mentor)
#    person3 = Factory(:person_mentor)
#    
#    person3.person_mentor_id = person2.id
#    person3.save!
#    person2.person_mentor_id = person1.id
#    person2.save!
#
#    get :discipleship, :id => person1.id
#    
#    assert_response :success   
# 
#     # test to see that default summary is shown (i.e. for the person at root of tree)    
#     xhr :get, :show_mentee_summary,
#      :mentee_id => person1.id
#       
#     assert_template :partial => '_mentee_summary', :count => 1
#     assert_response :success   
  end

  test "set initial campus validates first name" do
    login_admin_user
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:schoolyear_1)

    # submit without first name
    xhr :put, :set_initial_campus, {:person => {:first_name => "", :last_name => "leader", :gender => "1", :local_phone => "123-456-7890", :local_dorm => "", :major => ""},
                                    :primary_campus_involvement => {:campus_id => "2", :school_year_id => "1"}}
    assert_equal false, assigns(:person).errors.empty?
    assert_equal true, assigns(:primary_campus_involvement).errors.empty?
  end

  test "set initial campus validates last name" do
    login_admin_user
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:schoolyear_1)

    # submit without last name
    xhr :put, :set_initial_campus, {:person => {:first_name => "future", :last_name => "", :gender => "1", :local_phone => "123-456-7890", :local_dorm => "", :major => ""},
                                    :primary_campus_involvement => {:campus_id => "2", :school_year_id => "1"}}
    assert_equal false, assigns(:person).errors.empty?
    assert_equal true, assigns(:primary_campus_involvement).errors.empty?
  end

  test "set initial campus validates gender" do
    login_admin_user
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:schoolyear_1)

    # submit without gender
    xhr :put, :set_initial_campus, {:person => {:first_name => "future", :last_name => "leader", :gender => "", :local_phone => "123-456-7890", :local_dorm => "", :major => ""},
                                    :primary_campus_involvement => {:campus_id => "2", :school_year_id => "1"}}
    assert_equal false, assigns(:person).errors.empty?
    assert_equal true, assigns(:primary_campus_involvement).errors.empty?
  end

  test "set initial campus validates phone" do
    login_admin_user
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:schoolyear_1)

    # submit without phone
    xhr :put, :set_initial_campus, {:person => {:first_name => "future", :last_name => "leader", :gender => "1", :local_phone => "", :local_dorm => "", :major => ""},
                                    :primary_campus_involvement => {:campus_id => "2", :school_year_id => "1"}}
    assert_equal false, assigns(:person).errors.empty?
    assert_equal true, assigns(:primary_campus_involvement).errors.empty?
  end

  test "set initial campus validates campus" do
    login_admin_user
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:schoolyear_1)

    # submit without campus
    xhr :put, :set_initial_campus, {:person => {:first_name => "future", :last_name => "leader", :gender => "1", :local_phone => "123-456-7890", :local_dorm => "", :major => ""},
                                    :primary_campus_involvement => {:campus_id => "", :school_year_id => "1"}}
    assert_equal true, assigns(:person).errors.empty?
    assert_equal false, assigns(:primary_campus_involvement).errors.empty?
  end

  test "set initial campus validates school year" do
    login_admin_user
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:schoolyear_1)

    # submit without school year
    xhr :put, :set_initial_campus, {:person => {:first_name => "future", :last_name => "leader", :gender => "1", :local_phone => "123-456-7890", :local_dorm => "", :major => ""},
                                    :primary_campus_involvement => {:campus_id => "2", :school_year_id => ""}}
    assert_equal true, assigns(:person).errors.empty?
    assert_equal false, assigns(:primary_campus_involvement).errors.empty?
  end

  test "set initial campus validation pass" do
    barebones_login_admin_user
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:schoolyear_1)

    # submit with everything
    xhr :put, :set_initial_campus, {:person => {:first_name => "future", :last_name => "leader", :gender => "1", :local_phone => "123-456-7890", :local_dorm => "", :major => ""},
                                    :primary_campus_involvement => {:campus_id => "2", :school_year_id => "1"}}
    assert_equal true, assigns(:person).errors.empty?
    assert_equal true, assigns(:primary_campus_involvement).errors.empty?
  end

end
