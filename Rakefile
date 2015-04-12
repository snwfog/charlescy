require 'pathname'

JEKYLL_BUILD_PATH = File.expand_path('../blog', __FILE__)

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

task :octopress do
  sh "jekyll build #{JEKYLL_BUILD_PATH}/_config.yml"
end

task :bi do
  sh 'bundle check || bundle install'
end

