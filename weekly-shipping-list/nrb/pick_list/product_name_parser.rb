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
          name = string.split(/:/)[2]
          name.sub!(KEG_SIZE_REGEXP, '')
          name.sub!(/can case/i, '')
          name.sub!(/case - /i, '')
          name.sub!(/ 12x22oz/i, '')
          name.sub!(/^\s+|\s+$/, '')
          name
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
