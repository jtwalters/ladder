set :application, "imat.us"
set :repo_url,  "git@github.com:jtwalters/ladder.git"
set :scm, :git
set :branch, "master"
set :deploy_to, "/srv/www/#{application}/app"
set :pty, true

set :linked_files, %w{config/database.yml config/application.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :ssh_options, { :forward_agent => true }
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

set :rails_env, 'production'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
