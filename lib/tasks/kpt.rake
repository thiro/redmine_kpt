namespace :redmine do
  namespace :kpt => :environment do
    desc 'Install Redmine KPT plugin'
    task :install do
      ENV['NAME'] = 'redmine_kpt'
      ENV.delete 'VERSION'
      Rake::Task['redmine:plugins:migrate'].invoke
    end

    desc 'Uninstall Redmine KPT plugin with drop KTP database'
    task :uninstall => :environment do
      ENV['NAME'] = 'redmine_kpt'
      ENV['VERSION'] = '0'
      Rake::Task['redmine:plugins:migrate'].invoke
    end
  end
end
