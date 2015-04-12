desc "Copy emoji to the Rails `public/images/emoji` directory"
task :emoji do
  require 'emoji'
  target = "#{Rake.original_dir}/assets/images/emoji"
  if Dir.exists?(target)
    puts "Removing #{target}..."
    `rm -rf #{target}`
  end

  target_parent = Pathname.new(target).parent
  puts "Copying #{Emoji.images_path}/emoji >>> #{target_parent}..."

  `mkdir -p #{target} && cp -Rp #{Emoji.images_path}/emoji #{target_parent}`
end

task :restart do
  pid = `cat /home/unicorn/pids/unicorn.pid`.rstrip
  return if pid.empty?

  puts "Killing unicorn process #{pid}..."
  `kill -QUIT #{pid}`

  puts "Rebooting unicorn..."
  `unicorn -c /home/unicorn/unicorn.conf -D`
end
