Gem::Specification.new do |s|
  s.name = 'super_exception_notifier'
  s.version = '1.6.7'
  s.date = '2009-08-14'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.summary = %q{Allows unhandled (and handled!) exceptions to be captured and sent via email}
  s.description = %q{Allows customization of:
* the sender address of the email
* the recipient addresses
* the text used to prefix the subject line
* the HTTP status codes to send emails for
* the error classes to send emails for
* alternatively, the error classes to not send emails for
* whether to send error emails or just render without sending anything
* the HTTP status and status code that gets rendered with specific errors
* the view path to the error page templates
* custom errors, with custom error templates
* define error layouts at application or controller level, or use the controller's own default layout, or no layout at all
* get error notification for errors that occur in the console, using notifiable method
* Override the gem's handling and rendering with explicit rescue statements inline.}
  
  s.authors = ['Peter Boling', 'Jacques Crocker', 'Jamis Buck']
  s.email = 'peter.boling@gmail.com'
  s.homepage = 'http://github.com/pboling/exception_notification'
  s.require_paths = ["lib"]
  
  s.has_rdoc = true

  s.add_dependency 'rails', ['>= 2.1']
  
  s.files = ["MIT-LICENSE",
             "README.rdoc",
             "exception_notification.gemspec",
             "init.rb",
             "lib/super_exception_notifier/custom_exception_classes.rb",
             "lib/super_exception_notifier/custom_exception_methods.rb",
             "lib/exception_notifiable.rb",
             "lib/exception_notifier.rb",
             "lib/hooks_notifier.rb",
             "lib/exception_notifier_helper.rb",
             "lib/notifiable.rb",
             "rails/init.rb",
             "rails/app/views/exception_notifiable/400.html",
             "rails/app/views/exception_notifiable/403.html",
             "rails/app/views/exception_notifiable/404.html",
             "rails/app/views/exception_notifiable/405.html",
             "rails/app/views/exception_notifiable/410.html",
             "rails/app/views/exception_notifiable/418.html",
             "rails/app/views/exception_notifiable/422.html",
             "rails/app/views/exception_notifiable/423.html",
             "rails/app/views/exception_notifiable/501.html",
             "rails/app/views/exception_notifiable/503.html",
             "rails/app/views/exception_notifiable/method_disabled.html.erb",
             "views/exception_notifier/_backtrace.html.erb",
             "views/exception_notifier/_environment.html.erb",
             "views/exception_notifier/_inspect_model.html.erb",
             "views/exception_notifier/_request.html.erb",
             "views/exception_notifier/_session.html.erb",
             "views/exception_notifier/_title.html.erb",
             "views/exception_notifier/background_exception_notification.text.plain.erb",
             "views/exception_notifier/exception_notification.text.plain.erb",
             "VERSION.yml"]
  

  s.test_files = ["test/exception_notifier_helper_test.rb",
                  "test/exception_notify_functional_test.rb",
                  "test/test_helper.rb",
                  "test/mocks/404.html",
                  "test/mocks/500.html",
                  "test/mocks/controllers.rb"]

end
