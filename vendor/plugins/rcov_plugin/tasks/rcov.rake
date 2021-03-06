def run_coverage(files)
  #rm_f "coverage"
  #rm_f "coverage.data"
  
  # turn the files we want to run into a string
  if files.empty?
    puts "No files were specified for testing"
    return
  end
  
  files = files.join(" ")

  if RUBY_PLATFORM =~ /darwin/
    exclude = '--exclude "gems/*" --exclude "Library/Frameworks/*"'
  elsif RUBY_PLATFORM =~ /java/
    exclude = '--exclude "rubygems/*,jruby/*,parser*,gemspec*,_DELEGATION*,eval*,recognize_optimized*,yaml,yaml/*,fcntl"'
  elsif RUBY_PLATFORM =~ /linux/
    exclude_paths = "~/.gems/*,/var/lib/gems/*"
    exclude_paths += ",#{ENV['GEM_PATH']}/*" if ENV['GEM_PATH']
    exclude_paths += ",#{ENV['GEM_HOME']}/*" if ENV['GEM_HOME']
    exclude = '--exclude "' + exclude_paths + '"'
  else
    exclude = '--exclude "rubygems/*"'
  end
  # rake test:units:rcov SHOW_ONLY=models,controllers,lib,helpers
  # rake test:units:rcov SHOW_ONLY=m,c,l,h
  if ENV['SHOW_ONLY']
    params = String.new
    show_only = ENV['SHOW_ONLY'].to_s.split(',').map{|x|x.strip}
    if show_only.any?
      reg_exp = []
      for show_type in show_only
        reg_exp << case show_type
        when 'm', 'models' then 'app\/models'
        when 'c', 'controllers' then 'app\/controllers'
        when 'h', 'helpers' then 'app\/helpers'
        when 'l', 'lib' then 'lib'
        else
          show_type
        end
      end
      reg_exp.map!{ |m| "(#{m})" }
      params << " --exclude \"^(?!#{reg_exp.join('|')})\""
    end
    exclude = exclude + params
  end

  rcov_bin = RUBY_PLATFORM =~ /java/ ? "jruby -S rcov" : "rcov"
  aggregate = ENV['AGGREGATE'] ? " --aggregate #{ENV['AGGREGATE']}" : ""
  rcov = "#{rcov_bin} --rails -Ilib:test --sort coverage --text-report #{exclude}#{aggregate}"
  puts
  puts
  puts "Running tests..."
  cmd = "#{rcov} #{files}"
  #puts cmd
  sh cmd
end

namespace :test do
  
  desc "Measures unit, functional, helper, and integration test coverage"
  task :coverage do
    run_coverage Dir["test/unit/**/*.rb", "test/functional/**/*.rb", "test/integration/**/*.rb", "test/helpers/**/*.rb"]
  end
  
  namespace :coverage do
    desc "Runs coverage on unit tests"
    task :units do
      run_coverage Dir["test/unit/**/*.rb"]
    end
    
    desc "Runs coverage on functional tests"
    task :functionals do
      run_coverage Dir["test/functional/**/*.rb"]
    end
    
    desc "Runs coverage on integration tests"
    task :integration do
      run_coverage Dir["test/integration/**/*.rb"]
    end

    desc "Runs coverage on helper tests"
    task :helpers do
      run_coverage Dir["test/helpers/**/*.rb"]
    end
  end
end

