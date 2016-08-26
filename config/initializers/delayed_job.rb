# we want to keep failed jobs around since we want to be able to restart them
Delayed::Worker.destroy_failed_jobs = false

# default max_attempts is 25 which we found to be too high as it keeps retrying
# the job for many many days
Delayed::Worker.sleep_delay = 1.minute  # backoff is sleep_delay + attempts**4
Delayed::Worker.max_attempts = 10       # stops after about 3 hours

# the indexing jobs should never take more than max_run_time and
# our jobs are typically sub-second. we want to mark an error and
# move onto the next job if it does
Delayed::Worker.max_run_time = 5.minutes

# We want separate logging of the workers from the default Rails logger
Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayed_job.log'))
Delayed::Worker.logger.level = Logger::DEBUG
