# desc "Explaining what the task does"
# task :has_profile_items do
#   # Task goes here
# end

namespace :has_profile_items do
    
    desc 'Sets up parolkar\'s has_profile_items plugin '
    task :setup do
      
      raise 'has_profile_items plugin was only tested on unix & windows' if ! Rake.application.unix? &&  ! Rake.application.windows?
      
      files_to_be_copied = [
        {:source => "/vendor/plugins/has_profile_items/db/migrate/0_create_profile_items.rb", :target => "/db/migrate/#{migration_timestamp}_create_profile_items.rb" },
        {:source => "/vendor/plugins/has_profile_items/profile_items_config.rb", :target => "/config/initializers/has_profile_items.rb" },
        {:source => "/vendor/plugins/has_profile_items/public/images/has_profile_items", :target => "/public/images/has_profile_items/" },
        ]
      
      root = "#{Rails.root}"
      FileUtils.mkdir_p("#{root}/db/migrate") unless File.exists?("#{root}/db/migrate")
      files_to_be_copied.each {|ftbc|
        FileUtils.cp_r(root+ftbc[:source], root+ftbc[:target]) #:force => true)
        puts "Created : #{ftbc[:target]}"
      }
      
      puts "Running \"rake db:migrate\" for you..."
      Rake::Task["db:migrate"].invoke
      
      welcome_screen
     
    end
 
    def migration_timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end  
    
    def welcome_screen
    
    mesg = <<HERE
Congratulations for setting the plugin! There are few things to remember here...

1.) Make sure your application layout has "javascript_include_tag :defaults" , for helpers to work

Enjoy!
HERE

    puts mesg      
    end
    
end