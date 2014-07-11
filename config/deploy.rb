# config valid only for Capistrano 3.1
lock '3.2.1'

set :application,  'bearking.co'
set :app_name,     "bearking.co"
set :repo_url,     'git@github.com:thoughtpunch/bearking.co.git'
set :repository,   'git@github.com:thoughtpunch/bearking.co.git'
set :user,         "deploy"
set :scm,          :git
set :scm_username, "thoughtpunch"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    foreman.export

    # on OS X the equivalent pid-finding command is `ps | grep '/puma' | head -n 1 | awk {'print $1'}`
    run "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || #{sudo} service #{app_name} restart"

    # foreman.restart # uncomment this (and comment line above) if we need to read changes to the procfile
  end

end

# config/deploy.rb

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    run "cd #{current_path} && #{sudo} foreman export upstart /etc/init -a #{app_name} -u #{user} -l /var/#{app_name}/log"
  end

  desc "Start the application services"
  task :start do
    run "#{sudo} service #{app_name} start"
  end

  desc "Stop the application services"
  task :stop do
    run "#{sudo} service #{app_name} stop"
  end

  desc "Restart the application services"
  task :restart do
    run "#{sudo} service #{app_name} start || #{sudo} service #{app_name} restart"
  end
end
