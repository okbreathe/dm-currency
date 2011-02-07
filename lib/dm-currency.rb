require 'dm-core'

module DataMapper
  class Property
    class Currency < Integer

      DEFAULT = {
        :separator => '.',
        :precision => 2
      }

      def custom?
        true
      end

      def initialize(model, name, options = {}, type = nil)
        @currency_options = [:separator, :precision].inject({}) { |m,v| m[v] = options[v] ? options.delete(v) : DEFAULT[v]; m }
        @currency_options[:regexp] = ::Regexp.new("[^\\d#{::Regexp.escape(@currency_options[:separator])}]")
        super
      end

      # Typecast string/float to integer value
      # ==== Examples
      # "3"     -> 300
      # "30"    -> 3000
      # "30.75" -> 3075
      # "30.0"  -> 3000
      # "3.0.0" -> 3000
      # "30."   -> 3000
      # "0030"  -> 3000
      def load(value)
        precision = @currency_options[:precision]
        sep       = @currency_options[:separator]
        regexp    = @currency_options[:regexp]
        if value.kind_of? ::Float
          (value * 100)
        elsif value.kind_of? ::String
          value.gsub!(regexp,'')
          value = value.split(sep)
          if value.length > 1
            tail  = value.pop
            tail += "0" while tail.length < precision  
            value.join("") + tail[ 0, precision ]
          else
            value[0] + "00"
          end
        elsif value.kind_of? ::Integer
          value
        else
          raise ArgumentError, "amount must be a Float, Integer or String, but was `#{value.class}`"
        end.to_i
      end

      def typecast_to_primitive(value)
        load(value)
      end

    end # class Currency
  end # class Property
end # module DataMapper
