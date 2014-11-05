#!/usr/bin/env ruby

require 'nrb/beerxml'

module NRB

  module AddableAmount
    def +(other)
#      raise "Don't have an amount" unless respond_to?(:amount) && other.respond_to?(:amount)
      result = dup
      result.amount += other.amount
      result
    end
  end

  module ComparableName
    include Comparable
    def <=>(other)
#      raise "Don't have an name" unless respond_to?(:name) && other.respond_to?(:name)
      name <=> other.name
    end
  end


  module BeerXML
    class Hop;         include AddableAmount; include ComparableName; end
    class Fermentable; include AddableAmount; include ComparableName; end
    class Misc;        include AddableAmount; include ComparableName; end
    class Yeast;       include AddableAmount; include ComparableName; end
  end


  class Presenter

    attr_reader :tallier

    def initialize(tallier: Tallier.new)
      @tallier = tallier
    end


    def present
      tallier.results.sort.each do |result|
        printf "%8.2f %s\n", result.amount, result.name
      end
    end

  end


  class Tallier

    include NRB::BeerXML::Inflector

    attr_reader :results

    def initialize
      @results = []
    end


    def tally(items: [])
      items.each do |item|
        meth = "tally_" + underscore(item.class.name.split(/::/).last)
        respond_to?(meth,true) && send(meth, item)
      end
    end

  private

    def pos_in_results(item)
      @results.each_with_index do |result,i|
        if item.name == result.name
          return i
        end
      end
      -1
    end


    def tally_item(item)
      # Not thread-safe !hah!
      pos = pos_in_results(item)
      if pos == -1
        @results << item.dup
      else
        @results[pos] += item
      end
    end
    alias_method :tally_fermentable, :tally_item
    alias_method :tally_hop, :tally_item
    alias_method :tally_misc, :tally_item


    def tally_items(items)
      items.each do |item|
        tally_item item
      end
    end


    def tally_recipe(recipe)
      %i( fermentables hops miscs yeasts ).each do |ingredient|
        tally_items recipe.send(ingredient)
      end
    end

  end

end


parser = NRB::BeerXML::Parser.new
tallier = NRB::Tallier.new

ARGV.each do |arg|
  ingredients = parser.parse(arg)
  tallier.tally items: ingredients
end

presenter = NRB::Presenter.new tallier: tallier
presenter.present
