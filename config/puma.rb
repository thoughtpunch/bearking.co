root = "#{Dir.getwd}"
rackup "#{root}/config.ru"

threads 4, 8

activate_control_app
