desc "Copy emoji to the Rails `public/images/emoji` directory"
task :emoji do
  require 'emoji'

  target = "#{Rake.original_dir}/assets/images/emoji"
  if Dir["#{target}/*"].empty?
    `mkdir -p #{target} && cp -Rp #{Emoji.images_path}/emoji #{target}`
  else
    raise "Emoji assets folder #{target} is not empty"
  end
end
