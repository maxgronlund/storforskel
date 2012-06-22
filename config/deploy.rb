# RVM bootstrap
#$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2-p136'
set :rvm_type, :user
#set :rvm_bin_path, "/usr/local/rvm/bin"

# bundler bootstrap
require 'bundler/capistrano'
load 'deploy/assets'

# main details
set :application, "storforskel"                               # <<< change name
server "46.4.64.81", :app, :web, :db, :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :user, "deploy"
set :use_sudo, false

# repo details
set :scm , :git
set :repository, "git@github.com:maxgronlund/storforskel.git"  # <<< change reposotory
set :branch, "master"
set :git_enable_submodules, 1

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'


desc "Tail all or a single remote file"
task :tail do
  ENV["LOGFILE"] ||= "*.log"
  run "tail -f #{shared_path}/log/#{ENV["LOGFILE"]}" do |channel, stream, data|
    puts "#{data}"
    break if stream == :err
  end
end

