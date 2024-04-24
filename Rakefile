# frozen_string_literal: true

require "bundler/gem_tasks"

require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop)

RuboCop::RakeTask.new("rubocop:md") do |task|
  task.options << %w[-c .rubocop/docs.yml]
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

desc "Run RSpec code examples without VCR cassettes"
task "spec:no_vcr" do
  ENV["NO_VCR"] = "1"

  Rake::Task[:spec].invoke

  ENV.delete("NO_VCR")
end

task default: %i[rubocop rubocop:md spec spec:no_vcr]
