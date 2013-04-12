namespace :db do

  desc 'Dumps the entire database to an sql file.'
  task :dump => :environment do
    
    db_config = Rails.configuration.database_configuration
    user = db_config[Rails.env]['username']
    password = db_config[Rails.env]['password']
    host = db_config[Rails.env]['host']
    database = ENV['db'].try(:split, ',') || db_config[Rails.env]['database']
    
    File.mkdir(Rails.root.join("tmp")) unless File.directory?(Rails.root.join("tmp"))
    filename = Rails.root.join("tmp/dump-#{Rails.env}-#{Time.now.strftime('%Y-%m-%d')}.sql")
    puts "Dumping #{database} to #{filename}"
    
    command = 'mysqldump'
    command += ' --add-drop-table'
    command += " -u #{user}"
    command += " -h #{host}" unless host.blank?
    command += " -p#{password}" unless password.blank?
    command += " #{database}"
    command += " > #{filename}"
    
    sh command
  end
  
  # useful links
  # http://stackoverflow.com/questions/1049728/how-do-i-see-what-character-set-a-database-table-column-is-in-mysql
  # http://www.mysqlperformanceblog.com/2009/03/17/converting-character-sets/
  # http://stackoverflow.com/questions/1476356/detecting-utf8-broken-characters-in-mysql
  desc "Fixes accents"
  task :fix => :environment do
    db_config = Rails.configuration.database_configuration
    database = db_config[Rails.env]['database']
    tables = ENV['tables'].try(:split, ',') || ActiveRecord::Base.connection.tables
    tables.each do |table|
      fields = ENV['fields'].try(:split, ',') || ActiveRecord::Base.connection.select_values("SHOW FIELDS FROM #{table}")
      fields.each do |field|
        field_type = ActiveRecord::Base.connection.select_value("SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = '#{database}' AND table_name = '#{table}' AND COLUMN_NAME = '#{field}'");
        next unless field_type == "varchar"
        field_length = ActiveRecord::Base.connection.select_value("SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = '#{database}' AND table_name = '#{table}' AND COLUMN_NAME = '#{field}'");
        fix_encoding_sql = "ALTER TABLE `#{table}` DEFAULT CHARSET=utf8, MODIFY COLUMN `#{field}` varchar(#{field_length}) CHARACTER SET utf8;"
        ActiveRecord::Base.connection.execute(fix_encoding_sql)
        %|
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ©','é');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ«','ë');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ¨','è');
update `#{table}` set `#{field}` = replace(`#{field}` ,'Ãƒâ€°','É');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ´','ô');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ¡','á');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ¤','ä');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ¸','ø');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ¼','ü');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ¼³','ü');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ³','ó');
update `#{table}` set `#{field}` = replace(`#{field}` ,'ÃƒÂ','í');
|.split("\n").each do |cmd|
          if cmd.present?
            puts cmd
            puts ActiveRecord::Base.connection.execute(cmd)
          end
        end
      end
    end
  end
end

