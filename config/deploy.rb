require "rvm/capistrano"
require "bundler/capistrano"

set :user, "joel"
set :use_sudo, false

set :application, "ladder"
set :repository,  "git@github.com:jtwalters/ladder.git"

set :scm, :git
set :branch, "master"

set :deploy_to, "/srv/www/rb.joelwalters.com/app"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

server "rb.joelwalters.com", :app, :web, :db, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
