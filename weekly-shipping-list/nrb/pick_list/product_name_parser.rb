module NRB
  class PickList
    class ProductNameParser

      def self.parse(name, product_class: NRB::Product)
        return nil if name.nil?
        result = name.split(/:/)
        return nil unless result[0] == 'Ale'
        if result.size == 4
          product_class.new brand: result[3],
                            package: result[1],
                            package_size: result[2]
        else
          product_class.new brand: result[2],
                            package: result[1]
        end
      end

    end
  end
end
