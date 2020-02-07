#!/usr/bin/env rails runner
# frozen_string_literal: true

if $0 == __FILE__
  Rails.logger.info("runner #{__FILE__}")
  ResetCountTemplateJob.perform_later
end
