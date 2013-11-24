set :output, "#{path}/log/cron.log"

job_type :runner, "cd :path && bin/rails runner -e :environment ':task' :output"

every :monday, at: "00:01" do
  runner "RatingPeriodProcessor.perform"
end

every :monday, :at => "12:00" do
  rake "-s sitemap:refresh"
end

every :day, :at => "00:00" do
  runner "ChallengeProcessor.perform"
end
