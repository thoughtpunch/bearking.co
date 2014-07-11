# config valid only for Capistrano 3.1
lock '3.2.1'

set :application,  'bearking.co'
set :app_name,     "bearking.co"
set :repo_url,     'git@github.com:thoughtpunch/bearking.co.git'
set :repository,   'git@github.com:thoughtpunch/bearking.co.git'
set :user,         "deploy"
set :scm,          :git
set :scm_username, "thoughtpunch"


namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles :all do
      execute "cd #{current_path} && foreman export upstart /etc/init -a bearking.co -u deploy -l /var/www/bearking.co/current/log"
    end
  end

  desc "Start the application services"
  task :start do
    on roles :all do
      execute "sudo service bearking.co start"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles :all do
      execute "sudo service bearking.co stop"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles :all do
      execute "sudo service bearking.co start || sudo service bearking.co restart"
    end
  end
end


namespace :deploy do
  task :restart do
    on roles :all do
      foreman.export
      execute "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || sudo service bearking.co restart"
    end
  end
end
