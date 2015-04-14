require 'pathname'

APP_DIR = File.dirname(__FILE__)
REMOTE_DIR = '/home/charlescy'
REMOTE_HOST = 'charlescy'
JEKYLL_BUILD_PATH = File.expand_path('../blog', __FILE__)
EXCLUDED_PATH = %w(.* vendor tmp emoji log _site)

desc 'Refresh the app once it is deployed on the remote server'
task refresh: %i(bi parallel restart) do
  puts 'Refreshing the app...'
end

desc 'Parallels tasks'
multitask parallel: %i(emoji blog create_log) do
  puts 'Doing multi-tasks'
end

desc 'Copy emoji to the Rails `public/images/emoji` directory'
task :emoji do
  require 'emoji'
  target = "#{Rake.original_dir}/assets/images/emoji"
  rm_rf target if Dir.exists?(target)

  target_parent = Pathname.new(target).parent
  mkdir target and sh "cp -Rp #{Emoji.images_path}/emoji #{target_parent}"
end

task restart: %i(bi) do
  pid = `cat /home/unicorn/pids/unicorn.pid`.rstrip
  unless pid.empty?
    puts "Killing unicorn process #{pid}..."
    sh "kill -QUIT #{pid}"
  end

  puts "Starting unicorn process..."
  # FIXME: Allow bundle exec to be run on unicorn ie. use sh
  if system('unicorn -c /home/unicorn/unicorn.conf -D')
    puts 'Successfully restarted unicorn...'
  end
end

task :blog do
  chdir JEKYLL_BUILD_PATH
  puts "Generating the static Octopress site..."
  sh "jekyll build"
end

task :bi do
  sh 'bundle check || bundle install'
end

task :upload do
  exclude_list = EXCLUDED_PATH.inject('') { |sum, path| sum << %Q( --exclude '#{path}') }
  sh "rsync -IravzP #{APP_DIR} #{REMOTE_HOST}:#{Pathname.new(REMOTE_DIR).parent} #{exclude_list}"
end

task :create_log do
  mkdir 'log'                 unless Dir.exists?('log')
  touch 'log/development.log' unless File.exists?('log/development.log')
  sh 'chmod -R 777 log'
end


