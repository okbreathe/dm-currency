require 'dm-core'

module DataMapper
  class Currency

    DEFAULT = {
      :separator => '.',
      :precision => 2
    }

    attr_reader :value, :precision, :options

    def initialize(value, opts = DEFAULT)
      @options   = opts
      @precision = options[:precision]
      @value     = load(value)
    end

    def to_f
      value / 10**precision.to_f
    end

    def to_s(fmt = nil)
      sprintf( fmt || "%.#{precision}f", to_f )
    end

    alias :as_json :to_s

    def to_yaml(*args)
      to_s.to_yaml(*args)
    end

    def to_i
      value
    end

    # True if currency values have the same value
    def eql?(other)
      self.class == other.class && @value == other.to_i
    end

    alias :== :eql?

    # Negates a Currency value.
    def -@
      self.class.new(- @value)
    end
    # Currency + (Currency | Number) => Currency
    def +(other)
      self.class.new((@value + from_float(other.to_f)).to_i, options)
    end

    # Currency - (Currency | Number) => Currency
    def -(other)
      self.class.new((@value - from_float(other.to_f)).to_i, options)
    end

    # Currency * (Currency | Number) => Currency
    def *(other)
      self.class.new((@value * other.to_f).to_i, options)
    end

    # Currency / (Currency | Number) => Currency
    def /(other)
      self.class.new((@value / other.to_f).to_i, options)
    end

    protected

    # Convert value to Integer value
    # ==== Examples
    # "3"     -> 300
    # "30"    -> 3000
    # "30.75" -> 3075
    # "30.0"  -> 3000
    # "3.0.0" -> 3000
    # "30."   -> 3000
    # "0030"  -> 3000
    def load(value)
      case value
      when ::Float               then from_float(value)
      when ::String              then from_string(value)
      when ::Integer, ::NilClass then value
      else
        raise ArgumentError, "amount must be a Float, Integer or String, but was `#{value.class}`"
      end.to_i
    end

    def from_float(val)
      val * 10**precision
    end

    def from_string(val)
      val.gsub!(options[:regexp],'')
      val = val.split(options[:separator])
      if val.length >= precision
        tail  = val.pop
        tail += "0" while tail.length < precision  
        val.join("") + tail[ 0, precision ]
      elsif val.length == 0
        nil
      else
        "#{val[0]}#{'0'*precision}"
      end
    end

  end

  class Property
    class Currency < Integer

      def custom?
        true
      end

      def primitive?(value)
        value.kind_of?(::DataMapper::Currency)
      end

      def valid?(value, negated = false)
        ret = super || dump(value).kind_of?(::Integer)
      end

      def initialize(model, name, options = {})
        @currency_options = [:separator, :precision].inject({}) { |m,v| m[v] = options[v] ? options.delete(v) : ::DataMapper::Currency::DEFAULT[v]; m }
        @currency_options[:regexp] = ::Regexp.new("(^[^\\-\\d]?)|[^\\d#{::Regexp.escape(@currency_options[:separator])}]")
        super
      end

      def load(value)
        ::DataMapper::Currency.new(value, @currency_options) if value
      end

      def typecast_to_primitive(value)
        load(value)
      end

      def dump(value)
        return nil if DataMapper::Ext.blank?(value)
        value.to_i
      end

    end # class Currency
  end # class Property
end # module DataMapper
