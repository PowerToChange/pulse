require 'casclient'
require 'casclient/frameworks/rails/filter'

# enable detailed CAS logging
cas_logger = CASClient::Logger.new(RAILS_ROOT+'/log/cas.log')
cas_logger.level = Logger::DEBUG

CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url  => "https://signin.mygcx.org/cas/",
    :login_url     => "https://signin.mygcx.org/cas/login",
    :logout_url    => "https://signin.mygcx.org/cas/logout",
    :validate_url  => "https://signin.mygcx.org/cas/proxyValidate",    
    :proxy_retrieval_url => "https://www.globalshortfilmnetwork.com/cas_proxy_callback/retrieve_pgt",
    :proxy_callback_url => "https://www.globalshortfilmnetwork.com/cas_proxy_callback/receive_pgt",
    :username_session_key => :cas_user,
    :extra_attributes_session_key => :cas_extra_attributes,
    :logger => cas_logger,
    :authenticate_on_every_request => false
  )
