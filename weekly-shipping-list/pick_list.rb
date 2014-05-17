#!/usr/bin/env ruby

module NRB
  module PickList

    class Delivery

      include Comparable
      include Enumerable

      attr_accessor :line_items, :route, :ship_date

      class LineItem

        include Comparable

        attr_accessor :amount, :count, :product

        def <=>(other)
          product <=> other.product
        end

      end


      def <=>(other)
        ship_date <=> other.ship_date
      end


      def each(&block)
        line_items.each(&block)
      end


      def initialize
        @line_items = []
      end

    end

  end
end


require 'csv'

ship_dates = { }
total = 0

ARGV.each do |arg|
  row_num = -1

  CSV.foreach(arg) do |row|
    row_num += 1
    next if row_num == 0

    next if row[1..3].all? { |i| i.nil? }

    ship_date_array = row[0].split('/').collect(&:to_i)
    ship_date = Date.new( ship_date_array[2], ship_date_array[0], ship_date_array[1])

    route = row[1] || "No Route"

    raise ArgumentError, "No product in column 5, row #{row_num} of #{arg}" unless row[2]

    product = row[2]
    ship_dates[ship_date] ||= {}
    ship_dates[ship_date][route] ||= [0,Hash.new(0)]

    qty = row[3].to_i
    amt = row[4].to_f

    total += amt

    ship_dates[ship_date][route][0] += amt
    ship_dates[ship_date][route][1][product] += qty

  end
end

ship_dates.keys.sort.each do |date|
  puts "#{%w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)[date.wday]} #{date}"

  ship_dates[date].keys.sort.each do |route|

    printf "  %s $%.2f\n", route, ship_dates[date][route][0]

    ship_dates[date][route][1].keys.sort.each do |prod|
      printf "    %2i %s\n", ship_dates[date][route][1][prod], prod
    end
  puts
  end

end

printf "Total $%.2f\n", total
