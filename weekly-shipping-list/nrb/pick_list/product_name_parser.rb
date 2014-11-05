module NRB
  class PickList
    class ProductNameParser

      class << self

        KEG_SIZE_REGEXP = /(1\/[246])\s*bbl/i

        def parse(name, product_class: NRB::Product)
          return nil if name.nil?
          return nil unless name =~ /^Ale/

          product_class.new brand: brand(name),
                            package: package_type(name),
                            package_size: package_size(name)
        end

      private

        def brand(string)
          brands_with_expressions.each_pair.find do |name,exp|
            string.downcase =~ exp
          end.first
        end


        def brands_with_expressions
          { 'Dammit Jim!' => /dammit/i,
            'Kadigan'     => /kadigan/i,
            'Seasonal'    => /seasonal/i,
            'Skylight'    => /skylight/i,
            'Warimono'    => /wari/i,
            'Whipsaw'     => /whipsaw/i,
            'Windlass'    => /windlass/i
          }
        end


        def keg_size(string)
          size = KEG_SIZE_REGEXP.match(string)
          size && size.captures[0]
        end


        def package_size(string)
          string.split(/:/)[1] == 'Kegs' ? keg_size(string) : 'Case'
        end


        def package_type(string)
          string.split(/:/)[1].sub(/s$/, '')
        end

      end

    end
  end
end
