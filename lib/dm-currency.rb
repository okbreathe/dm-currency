require 'dm-core'

module DataMapper
  class Property
    class Currency < Integer

      def custom?
        true
      end

      # Typecast string/float to integer value
      # Two places of precision are assumed
      # ==== Examples
      # "3"     -> 300
      # "30"    -> 3000
      # "30.75" -> 3075
      # "30.0"  -> 3000
      # "3.0.0" -> 3000
      # "30."   -> 3000
      # "0030"  -> 3000
      def load(value)
        if value.kind_of? ::Float
          (value * 100)
        elsif value.kind_of? ::String
          value = value.split(".")
          if value.length > 1
            tail  = value.pop
            tail += "0" while tail.length < 2
            value.join("") + tail[0,2]
          else
            value[0] + "00"
          end
        elsif value.kind_of? ::Integer
          value
        else
          raise ArgumentError, "amount must be a Float, Integer or String"
        end.to_i
      end

      def typecast_to_primitive(value)
        load(value)
      end

    end # class Currency
  end # class Property
end # module DataMapper
