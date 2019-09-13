# Trust me its minitest

Some people prefer rspec others prefer minitest. But what if you didn't have to choose? What if you could just implement minitest on top of rspec? Then you could mix and match. No more bike shedding.

## Example

```ruby
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
```

And then run it

```
$ bundle exec ruby tests.rb
...

Finished in 0.00288 seconds (files took 0.06712 seconds to load)
3 examples, 0 failures
```
