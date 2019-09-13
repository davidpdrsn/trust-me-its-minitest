require_relative "trust_me_its_minitest"

class TestMe < Minitest::Test
  def setup
    @setup = true
  end

  def test_logic
    assert_equal true, true
  end

  def test_math
    assert_equal 2, 1 + 1
  end

  def test_setup
    assert @setup
  end
end
