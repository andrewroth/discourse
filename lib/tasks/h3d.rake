namespace :h3d do
  task :daemon => :environment do
    while true
      Rake::Task["h3d:user_messages"].execute
      puts "PROGRESS No h3d private messages require conversion, sleeping for 1 minute"
      sleep 60
    end
  end

  task :user_messages => :environment do
    H3d::User::Message.create_discourse
  end
end
