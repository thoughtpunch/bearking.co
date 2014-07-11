# config valid only for Capistrano 3.1
lock '3.2.1'

set :application,  'bearking.co'
set :app_name,     "bearking.co"
set :repo_url,     'git@github.com:thoughtpunch/bearking.co.git'
set :repository,   'git@github.com:thoughtpunch/bearking.co.git'
set :user,         "dan"
set :scm,          :git
set :scm_username, "thoughtpunch"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart, :roles => :app do
    foreman.export

    # on OS X the equivalent pid-finding command is `ps | grep '/puma' | head -n 1 | awk {'print $1'}`
    run "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || #{sudo} service #{app_name} restart"

    # foreman.restart # uncomment this (and comment line above) if we need to read changes to the procfile
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

# config/deploy.rb

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "cd #{current_path} && #{sudo} foreman export upstart /etc/init -a #{app_name} -u #{user} -l /var/#{app_name}/log"
  end

  desc "Start the application services"
  task :start, :roles => :app do
    run "#{sudo} service #{app_name} start"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    run "#{sudo} service #{app_name} stop"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "#{sudo} service #{app_name} start || #{sudo} service #{app_name} restart"
  end
end
