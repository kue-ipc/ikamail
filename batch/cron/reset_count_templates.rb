#!/usr/bin/env rails runner
# frozen_string_literal: true

if $0 == __FILE__
  Rails.logger.info("runner #{__FILE__}")
  Template.find_each do |template|
    template.update_column(:count, 0)
  end
end
