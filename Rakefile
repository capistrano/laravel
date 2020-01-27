# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i[spec rubocop]
RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop checks'
RuboCop::RakeTask.new
