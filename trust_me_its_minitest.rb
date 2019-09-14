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
    expect(a).to eq b
  end

  def refute_equal(a, b)
    expect(a).to_not eq b
  end

  def assert(a)
    expect(a).to be_truthy
  end

  def refute(a)
    expect(a).to be_falsy
  end

  attr_accessor :rspec

  def method_missing(name, *args, &block)
    if rspec.respond_to?(name)
      rspec.send(name, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(name, _)
    rspec.respond_to?(name) || super
  end
end

module Minitest
  class Test
    include Assertions

    def self.inherited(child)
      @@tests = []
    end

    def self.method_added(name)
      if name.to_s.match?(/^test_/)
        @@tests << name
      end
    end

    def self.generate_rspec_tests
      klass = self

      RSpec.describe self do
        if klass.new.respond_to?(:setup)
          before(:each) do
            instance = klass.new
            instance_variable_set(:"@__trust_me_instance", instance)

            instance.rspec = self
            instance.send(:setup)
          end
        end

        if klass.new.respond_to?(:teardown)
          after(:each) do
            instance = instance_variable_get(:"@__trust_me_instance") ||
              klass.new

            instance.rspec = self
            instance.send(:teardown)
          end
        end

        @@tests.each do |name|
          spec_doc =  name.to_s.sub("test_", "")
          it spec_doc do
            instance = instance_variable_get(:"@__trust_me_instance") ||
              klass.new

            instance.rspec = self
            instance.send(name)
          end
        end
      end
    end
  end
end
