task :import => :environment do
  ENV['importing'] = 'true'
  Rake::Task["environment"].execute
  load 'import_topics.rb'
end
