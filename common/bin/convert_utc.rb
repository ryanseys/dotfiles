#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "active_support/time"
require "active_support/time_with_zone"
require "active_support/isolated_execution_state"

date_string = ARGV.shift

if date_string.nil?
  puts "Please provide a date string as first argument"
else
  date_in_local_timezone = DateTime.parse(date_string).in_time_zone("America/Los_Angeles")

  puts date_in_local_timezone.strftime("%Y-%m-%d %H:%M:%S %p %Z (%z)")
end
