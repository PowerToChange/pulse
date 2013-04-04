set :keep_releases, '2'
set :user, 'deploy'
set :use_sudo, false
set :scm, 'git'
set :repository, "git://github.com/PowerToChange/pulse.git"
set :deploy_via, :checkout
set :git_enable_submodules, false
set :git_shallow_clone, true

after "deploy", "deploy:cleanup"

def link_shared(p, o = {})
  if o[:overwrite]
    run "rm -Rf #{release_path}/#{p}"
  end

  run "ln -s #{shared_path}/#{p} #{release_path}/#{p}"
end

task :production do
  role :app, 'pulse.powertochange.com'
  set :application, 'pulse'
  set :title, 'pulse'
  set :branch, 'master'
  set :deploy_to, "/var/www/pulse.powertochange.com"
end

task :staging do
  role :app, 'emu.powertochange.com'
  set :application, 'emu'
  set :branch, 'staging'
  set :deploy_to, '/var/www/emu.powertochange.com'
end

before :"deploy:create_symlink", :"deploy:before_symlink"
deploy.task :before_symlink do
  # set up tmp dir
  run "mkdir -p -m 770 #{shared_path}/tmp/{cache,sessions,sockets,pids}"
  run "rm -Rf #{release_path}/tmp"
  link_shared 'tmp'

  # other shared files / folders
  link_shared 'log', :overwrite => true
  link_shared 'config/database.yml', :overwrite => true
  link_shared 'config/session.yml', :overwrite => true
  link_shared 'config/mailer.yml', :overwrite => true
  link_shared 'config/civicrm.yml', :overwrite => true
  link_shared 'config/koala.yml', :overwrite => true
  link_shared 'config/initializers/eventbright.rb', :overwrite => true

  link_shared "public/emu.profile_pictures"

  run "cd #{release_path} && git checkout -b #{fetch(:branch)} origin/#{fetch(:branch)}"
  run "cd #{release_path} && git submodule init"
  run "cd #{release_path} && git submodule update"
end

after :"deploy:create_symlink", :"deploy:after_symlink"
deploy.task :after_symlink do
  run "ruby /etc/screen.d/dj_#{fetch(:application)}.rb"
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:reload, :start, :stop].each do |t|
    desc "#{t} task is not applicable to Passenger"
    task t, :roles => :app do ; end
  end

  namespace :views do
    desc "runs pulse:views:rebuild remotely"
    task :rebuild do
      rake = fetch(:rake, "rake")
      rails_env = fetch(:rails_env, "production")

      run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} pulse:views:rebuild"
    end
  end
end
