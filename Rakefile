# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:spec) do |t|
  t.libs << 'lib' << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
end

task default: :spec
