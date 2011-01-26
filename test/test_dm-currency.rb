require 'helper'
require 'data'

class TestDmCurrency < Test::Unit::TestCase
  context "A Currency Type" do

		should "set default currency arguments without arguments" do
			opts = Foo.new(:money => "3" ).send(:properties).last.instance_variable_get(:@currency_options)
			assert_equal opts[:separator], DataMapper::Property::Currency::DEFAULT[:separator]
			assert_equal opts[:precision], DataMapper::Property::Currency::DEFAULT[:precision]
		end

		should "allow you to override default currency arguments " do
			opts = Bar.new(:money => "3" ).send(:properties).last.instance_variable_get(:@currency_options)
			assert_equal opts[:separator], '^'
			assert_equal opts[:precision],  3
		end

		should "ignore invalid characters" do
      assert_equal( 300,     Foo.create(:money => "$3foobar"    ).money ) 
      assert_equal( 300,     Foo.create(:money => "$3.00foobar" ).money ) 
      assert_equal( 30000,   Foo.create(:money => "$3,00foobar" ).money ) 
      assert_equal( 2000000, Foo.create(:money => "20,000"      ).money ) 
      assert_equal( 2000000, Foo.create(:money => "20,000.00"   ).money ) 
		end

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
