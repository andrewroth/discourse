task :import do
  ENV['importing'] = 'true'
  Rake::Task["environment"].execute
  load 'import_topics.rb'
  H3d::User::Message.create_discourse
end
