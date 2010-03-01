class UsersController < ApplicationController
  filter_parameter_logging :password
  skip_before_filter :login_required, CASClient::Frameworks::Rails::GatewayFilter, :authorization_filter, :get_ministry, :force_required_data, :only => [:prompt_for_email, :link_fb_user]
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1;edit
  def edit
    @user = User.find(params[:id])
    respond_to do |wants|
      wants.html { render :partial => 'change_password', :locals => {:user => @user }}
      wants.js { render :partial => 'change_password', :locals => {:user => @user }}
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to user_url(@user) }
        format.xml  { head :created, :location => user_url(@user) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    # no blank passwords
    if params[:user][:plain_password] && params[:user][:plain_password].empty?
      @user.errors.add_to_base("Password can't be blank")
    end
    respond_to do |format|
      if @user.errors.empty?
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to user_url(@user) }
        format.xml  { head :ok }
        format.js   # Changing password
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
        format.js   { render :action => :edit } # Changing password
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.xml  { head :ok }
    end
  end
  
  def prompt_for_email
    unless facebook_session
      redirect_to '/' and return
    end
  end
  
  def link_fb_user
    unless params[:email] =~ Authentication.email_regex
      flash[:warning] = "We really need you to enter a valid email address"
      render :prompt_for_email and return
    end
    if facebook_session
      if !current_user || current_user == :false
        #register with fb
        self.current_user = User.create_from_fb_connect(facebook_session.user, params[:email])
        redirect_to set_initial_campus_person_url(current_user.person)
      else
        #connect accounts
        self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
        redirect_to person_path(current_user.person)
      end
    else
      redirect_to '/'
    end
  end

end
