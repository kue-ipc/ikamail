#!/usr/bin/env ruby
# frozen_string_literal: true

require 'daemons'

Daemons.run(File.expand_path('rbslapd.rb', __dir__))
