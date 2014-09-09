#!/usr/bin/env ruby

require 'nokogiri'

module NRB
  class BeerXML

    class Parser
      attr_reader :reader

      def ingredient_types; %W( FERMENTABLES/FERMENTABLE HOPS/HOP MISCS/MISC ); end


      def initialize( reader: Nokogiri::XML, results_class: NRB::BeerXML::Ingredient )
        @reader = reader
        @results_class = results_class
      end


      def parse(file: nil)
        doc = parse_xml(file)
        results = []

        ingredient_types.each do |ingredient_type|
          doc.xpath("//#{ingredient_type}").each do |ingredients|
            results << @results_class.new( amount: ingredients.%("AMOUNT").content, name: ingredients.%("NAME").content )
          end
        end
        results
      end

    private

      def parse_xml(file)
        f = File.open(file)
        doc = reader.parse(f)
        f.close
        doc
      end

    end



    class Ingredient

      include Comparable

      attr_accessor :amount, :name

      def <=>(other)
         [name, amount] <=> [other.name, other.amount]
      end


      def +(other)
        raise ArgumentError "Trying to add different ingredients" unless eq(other)
        self.class.new amount: (amount + other.amount),
                       name: name
      end


      def eq(other)
        @name == other.name
      end


      def initialize(hash={})
        @amount = hash[:amount].to_f
        @name = hash[:name]
      end


      def to_s; "#{amount} #{name}"; end

    end


    class Presenter

      attr_reader :tallier

      def initialize(tallier: Tallier.new)
        @tallier = tallier
      end


      def present
        tallier.results.sort.each do |result|
          puts "#{result.amount} #{result.name}"
        end
      end

    end


    class Tallier

      attr_reader :results

      def initialize
        @results = []
      end


      def tally(items: [])
        # Not thread-safe !hah!
        items.each do |item|
          pos = pos_in_results(item)
          if pos == -1
           @results << item
          else
            @results[pos] += item
          end
        end
      end

    private

      def pos_in_results(item)
        @results.each_with_index do |result,i|
          if item.eq(result)
            return i
          end
        end
        -1
      end

    end

  end
end


parser = NRB::BeerXML::Parser.new
tallier = NRB::BeerXML::Tallier.new

ARGV.each do |arg|

  ingredients = parser.parse(file: arg)
  tallier.tally items: ingredients
end

presenter = NRB::BeerXML::Presenter.new tallier: tallier
presenter.present