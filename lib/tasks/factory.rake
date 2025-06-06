# Run `rake spec` to run the factory specs and then the main specs.
if defined?(RSpec)
  desc "Run factory specs"
  RSpec::Core::RakeTask.new(:factory_specs) do |t|
    t.pattern = "./spec/factories_spec.rb"
  end
end

task spec: :factory_specs
