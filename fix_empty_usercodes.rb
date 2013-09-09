base_url = "https://pulse.powertochange.com"
ucs = UserCode.all(:include => :login_code).find_all{ |uc| uc.login_code.code.blank? }
ucs.each do |uc|
  puts ""
  puts "uc id: #{uc.id}"
  puts "login_code id: #{uc.login_code.id}"
  if uc.pass['primary_campus_involvement']
    puts "Email #{uc.user.person.email} step2_email_verified"
    uc.login_code.code = ::LoginCode.new_code
    uc.login_code.save!
    link = uc.callback_url(base_url, "signup", "step2_email_verified")
    UserMailer.deliver_signup_confirm_email(uc.user.person.email, link, true)
  else
    puts "Email #{uc.user.person.email} timestable"
    uc.login_code.code = ::LoginCode.new_code
    uc.login_code.save!
    link = uc.callback_url(base_url, "signup", "timetable")
    UserMailer.deliver_signup_finished_email(uc.user.person.email, link, true)
  end
  raise "done one"
end
