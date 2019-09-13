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
end
