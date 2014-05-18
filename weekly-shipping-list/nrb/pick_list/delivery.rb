module NRB
  class PickList
    class Delivery

      extend Forwardable
      include Comparable

      attr_accessor :amount, :product, :quantity, :route, :ship_date

      def_delegators :@product, :bottle?, :brand, :can?, :case?, :half?,
                     :keg?, :package, :package_size, :quarter?, :sixtel?

      def +(other)
        raise ArgumentError "Trying to add different deliveries" unless eq(other)
        self.class.new amount:    (amount + other.amount),
                       product:   product,
                       quantity:  (quantity + other.quantity),
                       route:     route,
                       ship_date: ship_date
      end


      def <=>(other)
        [ship_date, route, product] <=> [other.ship_date, other.route, other.product]
      end


      def eq(other)
        (self <=> other) == 0
      end


      def initialize(hash={})
        [ :amount, :product, :quantity, :route, :ship_date ].each do |attr|
          send "#{attr}=", hash[attr]
        end
      end

    end
  end
end
