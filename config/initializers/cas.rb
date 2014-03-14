require 'casclient'
require 'casclient/frameworks/rails/filter'

# enable detailed CAS logging
cas_logger = CASClient::Logger.new(RAILS_ROOT+'/log/cas.log')
cas_logger.level = Logger::DEBUG

CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url  => "https://thekey.me/cas/",
    :login_url     => "https://thekey.me/cas/login",
    :logout_url    => "https://thekey.me/cas/logout",
    :validate_url  => "https://thekey.me/cas/proxyValidate",    
    :proxy_retrieval_url => "https://pulse.p2c.com/cas_proxy_callback/retrieve_pgt",
    :proxy_callback_url => "https://pulse.p2c.com/cas_proxy_callback/receive_pgt",
    :username_session_key => :cas_user,
    :extra_attributes_session_key => :cas_extra_attributes,
    :logger => cas_logger,
    :authenticate_on_every_request => true,
    :enable_single_sign_out => true
  )
