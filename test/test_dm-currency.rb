require 'helper'
require 'data'

class TestDmCurrency < Test::Unit::TestCase
  context "A Currency Type" do

		should "set default currency arguments without arguments" do
			opts = Foo.new(:money => "3" ).send(:properties).to_a.last.instance_variable_get(:@currency_options)
			assert_equal opts[:separator], DataMapper::Currency::DEFAULT[:separator]
			assert_equal opts[:precision], DataMapper::Currency::DEFAULT[:precision]
		end

		should "allow you to override default currency arguments " do
			opts = Bar.new(:money => "3" ).send(:properties).to_a.last.instance_variable_get(:@currency_options)
			assert_equal opts[:separator], '^'
			assert_equal opts[:precision],  3
		end

    should "return a DataMapper::Currency Object" do
      assert_kind_of(::DataMapper::Currency, Foo.create(:money => 1.00).money)
    end

    should "work" do
      f = Foo.create(:money => "10.00")
      assert_equal(false, f.new?)
    end

		should "set be nil without setting" do
      f = Foo.create
      assert_equal(false, f.new?)
      assert_nil(f.money)
      f = Foo.create(:money => nil)
      assert_nil(f.money)
		end

    should "allow basic arithmetic operations with numerics" do
      a = Foo.create(:money => "10.00").money
      assert_equal 100.0, (a*10).to_f
      assert_equal 100.0, (a*10.0).to_f
      assert_equal 5.0,   (a/2).to_f
      assert_equal 3.33,  (a/3.0).to_f
      assert_equal 23.0,  (a+13).to_f
      assert_equal 22.96, (a+12.96).to_f
      assert_equal 0.0,   (a-10).to_f
      assert_equal 0.0,   (a-10.00).to_f
    end

    should "allow basic arithmetic operations with other currencies" do
      a = Foo.create(:money => "10.00").money
      b = Foo.create(:money => "10.00").money
      c = Foo.create(:money => "20.00").money
      assert(a == b)
      assert(a.eql?(b))
      assert_equal(false,a == c)
      assert_equal(false,a.eql?(c))
      assert_equal 20.0,  (a+b).to_f
      assert_equal 0.0,   (a-b).to_f
      assert_equal 1.0,   (a/b).to_f
      assert_equal 100.0, (a*b).to_f
    end

    should "convert all String values to an integer" do
      assert_equal( -300, Foo.create(:money => "-3.00" ).money.value )
      assert_equal( 300,  Foo.create(:money => "3"     ).money.value )
      assert_equal( 3000, Foo.create(:money => "30"    ).money.value )
      assert_equal( 3075, Foo.create(:money => "30.75" ).money.value )
      assert_equal( 3000, Foo.create(:money => "30.0"  ).money.value )
      assert_equal( 3000, Foo.create(:money => "3.0.0" ).money.value )
      assert_equal( 3000, Foo.create(:money => "30."   ).money.value )
      assert_equal( 3000, Foo.create(:money => "0030"  ).money.value )
    end

    should "convert all Float values to an integer" do
      assert_equal( -300, Foo.create(:money => -3.00  ).money.value )
      assert_equal( 300,  Foo.create(:money => 3.0    ).money.value )
      assert_equal( 3000, Foo.create(:money => 30.0   ).money.value )
      assert_equal( 3000, Foo.create(:money => 30.00  ).money.value )
      assert_equal( 3000, Foo.create(:money => 30.000 ).money.value )
      assert_equal( 3075, Foo.create(:money => 30.75  ).money.value )
      assert_equal( 30,   Foo.create(:money => 0.30   ).money.value )
    end

    should "leave integers alone" do
      assert_equal( -300, Foo.create(:money => -300  ).money.value )
      assert_equal( 300,  Foo.create(:money => 300   ).money.value )
    end

    should "ignore invalid characters" do
      assert_equal( -300,    Foo.create(:money => "-$3foo-bar"  ).money.value )
      assert_equal( 300,     Foo.create(:money => "$3foobar"    ).money.value )
      assert_equal( 300,     Foo.create(:money => "$3.00foobar" ).money.value )
      assert_equal( 30000,   Foo.create(:money => "$3,00foobar" ).money.value )
      assert_equal( 2000000, Foo.create(:money => "20,000"      ).money.value )
      assert_equal( 2000000, Foo.create(:money => "20,000.00"   ).money.value )
    end

    should "allow you to get the value as a float" do
      assert_equal( -3.0, Foo.create(:money => -3.00 ).money.to_f )
      assert_equal( 3.0,  Foo.create(:money  => 3.0   ).money.to_f )
      assert_equal( 30.0, Foo.create(:money  => 30.0  ).money.to_f )
    end

    should "allow you to get the value as a string" do
      assert_equal( "-3.00", Foo.create(:money => "-3.00" ).money.to_s )
      assert_equal( "3.00",  Foo.create(:money => "3"     ).money.to_s )
      assert_equal( "30.00", Foo.create(:money => "30"    ).money.to_s )
    end

  end
end
