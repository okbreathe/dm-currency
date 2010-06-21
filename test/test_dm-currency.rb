require 'helper'
require 'data'

class TestDmCurrency < Test::Unit::TestCase
  context "A Currency Type" do

    should "convert all String values to an integer" do
      assert_equal( 300,  Foo.create(:money => "3"     ).money ) 
      assert_equal( 3000, Foo.create(:money => "30"    ).money )
      assert_equal( 3075, Foo.create(:money => "30.75" ).money )
      assert_equal( 3000, Foo.create(:money => "30.0"  ).money )
      assert_equal( 3000, Foo.create(:money => "3.0.0" ).money )
      assert_equal( 3000, Foo.create(:money => "30."   ).money )
      assert_equal( 3000, Foo.create(:money => "0030"  ).money )
    end

    should "convert all Float values to an integer" do
      assert_equal( 300,  Foo.create(:money => 3.0    ).money ) 
      assert_equal( 3000, Foo.create(:money => 30.0   ).money )
      assert_equal( 3000, Foo.create(:money => 30.00  ).money )
      assert_equal( 3000, Foo.create(:money => 30.000 ).money )
      assert_equal( 3075, Foo.create(:money => 30.75  ).money )
      assert_equal( 30,   Foo.create(:money => 0.30   ).money )
    end
  end
end
