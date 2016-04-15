# -*- coding: utf-8; mode: ruby -*-

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task test: :rubocop

task :rubocop do
  sh 'rubocop -R'
end

desc 'Run tests'
task default: :test
