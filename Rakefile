require 'pathname'


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
  return if pid.empty?

  puts "Killing unicorn process #{pid}..."
  sh "kill -QUIT #{pid}"

  puts 'Rebooting unicorn...'
  sh 'unicorn -c /home/unicorn/unicorn.conf -D' do
    puts 'Successfully restarted unicorn...'
  end
end

task :bi do
  sh 'bundle install'
end

