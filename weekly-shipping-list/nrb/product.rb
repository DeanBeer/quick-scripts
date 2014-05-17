module NRB
  class Product

    include Comparable

    attr_reader :brand, :package, :package_size

    def <=>(other)
      [brand, package, package_size] <=> [other.brand, other.package, other.package_size]
    end

    def bottle?; package == 'Bottles'; end
    def can?; package == 'Cans'; end
    def case?; bottle? || can?; end
    def half?; package_size == 0.5; end
    def keg?; package == 'Keg'; end
    def quarter?; package_size == 0.25; end
    def sixtel?; package_size == 0.16; end

    def initialize(brand: nil, package: nil, package_size: nil)
      @brand = brand
      @package = package
      @package_size = package_size
    end

  end
end