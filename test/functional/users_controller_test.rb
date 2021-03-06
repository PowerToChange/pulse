require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    setup_years
    setup_months
    
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:users)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_user
    old_count = User.count
    post :create, :user => {:username => 'josh.starcher', :guid => 'G67854H-34G3-7890-6N22-6H4H3FG6D456', :last_login => Date.today }
    assert_equal old_count+1, User.count
    
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_should_NOT_create_user
    old_count = User.count
    post :create, :user => { }
    assert_equal old_count, User.count
    assert_response :success
    assert_template 'new'
  end

  def test_should_show_user
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_user
    put :update, :id => 1, :user => { }
    assert assigns(:user)
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_should_NOT_update_user
    put :update, :id => 1, :user => {:username => '' }
    assert_response :success
    assert_template 'edit'
  end

  def test_should_destroy_user
    setup_users

    assert_difference('User.count', -1) do
      delete :destroy, :id => 3
    end

    assert_redirected_to users_path
  end

  
end

