task :hourly_batch_report => :environment do
  # rake task for existing data request but no profile associated to it
  Mailer.delay.hourly_report
end

