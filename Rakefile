require 'pathname'
require 'tilt'
require 'slim'
require 'colorize'
require 'rake/remote_task'
require 'yaml'

require_relative 'helpers/rendering'
include Ohaider::Helpers

Rake.application.options.trace_rules = true

APP_PATH           = File.dirname(__FILE__)
REMOTE_DIR        = '/home/charlescy'
REMOTE_HOST       = 'charlescy'
JEKYLL_BUILD_PATH = File.expand_path('../blog', __FILE__)
EXCLUDED_PATH     = %w(.* vendor tmp emoji log)

VIEW_SLIM_TEMPLATES = Rake::FileList['views/*.slim']
ASSET_SCSS_FILES = Rake::FileList['blog/css/*.scss'].exclude(/main/)

# Remote task
set :domain, "root@104.236.93.109:#{REMOTE_DIR}"
set :target_dir, APP_PATH

task default: :deploy

desc 'Deploy'
task deploy: %W(bi create_log local:emoji local:blog local:compile local:css local:sync) do
end

desc 'Setup the app remotely'
remote_task :remote_setup do
  run 'bundle exec rake remote:setup'
end

desc 'Checking for bundle and running bundle install if needed'
task :bi do
  sh 'bundle check || bundle install'
end

desc 'Create development log if does not exist'
task :create_log do
  mkdir "#{APP_PATH}/log" unless Dir.exists?("#{APP_PATH}/log")
  unless File.exists?("#{APP_PATH}/log/development.log")
    touch "#{APP_PATH}/log/development.log"
  end
  sh 'chmod -R 777 log'
end

namespace :local do
  task :sync do
    exclude_list = EXCLUDED_PATH.inject('') { |sum, path| sum << %Q( --exclude '#{path}') }
    sh "rsync --delete --quiet -IravzP #{APP_PATH} #{REMOTE_HOST}:#{Pathname.new(REMOTE_DIR).parent} #{exclude_list}"
  end

  # desc 'Compile local tasks before syncing with remote'
  # multitask prepare: %w(local:emoji local:blog), &(->{})

  desc 'Copy emoji to the Rails `public/images/emoji` directory'
  task :emoji do
    require 'emoji'
    target = "#{Rake.original_dir}/assets/images/emoji"
    rm_rf target if Dir.exists?(target)

    target_parent = Pathname.new(target).parent
    mkdir target and sh "cp -Rp #{Emoji.images_path}/emoji #{target_parent}"
  end

  desc 'Generate Jekyll static blog'
  task :blog do
    chdir JEKYLL_BUILD_PATH
    puts 'Generating the static Octopress site...'
    sh 'bundle exec jekyll build >> /dev/null'
    # Change dir back.. this was causing rake to fail
    # if anything gets run after this task
    chdir APP_PATH
    puts 'You need to run the compile task...'.red
  end

  task compile: VIEW_SLIM_TEMPLATES.ext('.html')
  # WARN: THIS SHIT WORKS ONLY WHEN ITS INDEX.HTML
  rule '.html' => '.slim' do |t|
    raise 'Cannot compile, tidy5 does not exists' if `which tidy5`.empty?
    dir_path  = "#{APP_PATH}/tmp/#{t.source.pathmap('%d')}"
    file_path = "#{dir_path}/#{t.source.pathmap('%n')}"
    begin
      mkdir_p dir_path unless Dir.exists?(dir_path)
      template = Tilt.new(t.source)
      # Create a temporary file to write the compiled html into
      touch "#{file_path}.html.tmp"
      # Render the template into the tmp file
      File.open("#{file_path}.html.tmp", 'w') do |f|
        f.puts template.render(self)
      end
      sh "tidy5 -indent -quiet -output #{file_path}.html #{file_path}.html.tmp"
      mv "#{file_path}.html", "#{APP_PATH}/#{file_path.pathmap('%n')}.html"
      # INFO: redundant a bit, can move from tmp directly into its proper location...
      mv "#{APP_PATH}/#{file_path.pathmap('%n')}.html", "#{JEKYLL_BUILD_PATH}/_site/#{file_path.pathmap('%n')}.html"
    ensure
      puts 'Cleaning up the temporary generated view folder'
      rm_r dir_path
    end
  end

  task css: ASSET_SCSS_FILES.ext('.css')
  rule '.css' => '.scss' do |t|
    raise 'Cannot find the scss preprocessor'.red if `which scss`.empty?
    file_path = "#{APP_PATH}/#{t.source.pathmap('%X')}"
    sh "scss --sourcemap=none #{file_path}.scss #{file_path}.css"
  end
end

namespace :remote do
  task restart: %i(bi) do
    puts 'Changing access right to the app dir'
    sh "chown -R www-data:www-data #{REMOTE_DIR}"

    pid = `cat /home/unicorn/pids/unicorn.pid`.rstrip
    unless pid.empty?
      puts "Killing unicorn process #{pid}..."
      sh "kill -QUIT #{pid}"
    end

    puts 'Starting unicorn process...'.green
    # FIXME: Allow bundle exec to be run on unicorn ie. use sh
    if system('unicorn -c /home/unicorn/unicorn.conf -D')
      puts 'Successfully restarted unicorn...'
    end

    puts 'Restarting nginx...'.green
    sh 'service nginx restart'
  end

  task setup: %i(bi create_log restart) do
  end
end

namespace :blog do
  task preview: %i(local:blog local:compile) do
    Rake::Task['blog:change_local'].invoke('dev')
    sh "cd #{JEKYLL_BUILD_PATH}; jekyll serve --skip-initial-build"
  end

  # May this will looks prettier
  # task :say_hello do
  #   name = ARGV.last
  #   puts "Hello, #{name}."
  #   task name.to_sym do ; end
  # end

  task :change_local, [:environment] do |t, args|
    environment = args[:environment] || 'development'
    yaml = YAML.load_file("#{JEKYLL_BUILD_PATH}/_config.yml")
    case environment
    when /dev/
      yaml['baseurl'] = '' # Set to base path
    else
      yaml['baseurl'] = '/blog'
    end

    File.open("#{JEKYLL_BUILD_PATH}/_config.yml", 'w') do |f|
      f.puts yaml.to_yaml
    end
  end
end
