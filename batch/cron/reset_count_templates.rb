#!/usr/bin/env rails runner
if $0 == __FILE__
  Rails.logger.info("runner #{__FILE__}")
  ResetCountTemplateJob.perform_later
end
