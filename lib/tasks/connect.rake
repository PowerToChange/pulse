namespace :connect do
  task :import_contacts => :environment do
    include Connect
    Connect.import_survey_contacts(1)
  end
end