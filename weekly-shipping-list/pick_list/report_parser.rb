module NRB
  module PickList

    class ReportParser

      def initialize( order_data: [], reader: CSV, results_class: NRB::PickList::Delivery )
        @order_data = order_data
        @reader = reader
        @results_class = results_class
      end


      def parse( args: {headers: true} )
        @reader.parse(@order_data, args).collect do |row|
          next unless valid_row?(row)
          results_class.new row_to_hash(row)
        end.compact
      end


    private

      def cols
        {
          amount:    4,
          product:   2,
          quantity:  3,
          route:     1,
          ship_date: 0
        }
      end


      def parse_date(string)
        date_array = string.split('/').collect(&:to_i)
        Date.new date_array[2], date_array[0], date_array[1]
      end


      def row_to_hash(row)
        { amount:    row[ cols[:amount]    ].to_f,
          product:   row[ cols[:product]   ],
          quantity:  row[ cols[:quantity]  ].to_i,
          route:     row[ cols[:route]     ],
          ship_date: parse_date(row[ cols[:ship_date] ])
        }
      end


      def valid_row?(row)
        return false unless row[ cols[:amount] ]
        ! row[1..3].all? { |i| i.nil? }
      end

    end

  end
end
