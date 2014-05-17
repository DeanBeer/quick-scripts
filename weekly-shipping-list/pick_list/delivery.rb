module NRB
  module PickList

    class Delivery

      include Comparable

      attr_accessor :amount, :product, :quantity, :route, :ship_date

      def <=>(other)
        ship_date <=> other.ship_date
      end


      def initialize(hash={})
        [ :amount, :product, :quantity, :route, :ship_date ].each do |attr|
          send "#{attr}=", hash[attr]
        end
      end

    end

  end
end
