require "rspec/autorun"

TracePoint.new(:end) do |tp|
  klass = tp.self

  if defined?(Minitest) &&
      defined?(Minitest::Test) &&
      klass != Minitest::Test &&
      klass.ancestors.include?(Minitest::Test)
    klass.generate_rspec_tests
  end
end.enable

module Assertions
  def assert_equal(a, b)
    rspec.expect(a).to(rspec.equal(b))
  end

  def assert(a)
    rspec.expect(a).to(rspec.be_truthy)
  end

  attr_accessor :rspec
end

module Minitest
  class Test
    def self.inherited(child)
      @@tests ||= []

      child.instance_eval do
        def self.method_added(name)
          if name.to_s.match?(/^test_/)
            @@tests << name
          end
        end

        include Assertions
      end
    end

    def self.generate_rspec_tests
      instance = new

      RSpec.describe self do
        @@tests.each do |name|
          if instance.respond_to?(:setup)
            before(:each) do
              instance.rspec = self
              instance.send(:setup)
            end
          end

          spec_doc =  name.to_s.sub("test_", "")
          it spec_doc do
            instance.rspec = self
            instance.send(name)
          end
        end
      end
    end
  end
end
