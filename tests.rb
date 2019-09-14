require_relative "trust_me_its_minitest"

class TestMe < Minitest::Test
  def setup
    @setup_executed ||= 0
    @setup_executed += 1
  end

  def teardown; end

  def test_logic
    assert true
    refute false
    assert_equal true, true
  end

  def test_math
    assert_equal 2, 1 + 1
    refute_equal 1337, 1 + 1
  end

  def test_setup
    assert_equal @setup_executed, 1
  end

  def test_calling_helper_method
    assert_equal 1, helper_method
  end

  def test_rspec_expectations_still_work
    expect([]).to be_empty
  end

  private

  def helper_method
    1
  end
end

class TeardownReusesInstanceTests < Minitest::Test
  def test_foo
    @foo = true
  end

  def teardown
    assert @foo
  end
end
