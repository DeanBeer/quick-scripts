$:.unshift(File.dirname(__FILE__))  # UNHACKME
module NRB
  class PickList

    include Enumerable

    autoload :Delivery, 'pick_list/delivery'
    autoload :Mix, 'pick_list/mix'
    autoload :ProductNameParser, 'pick_list/product_name_parser'
    autoload :Parser, 'pick_list/parser'
    autoload :Presenter, 'pick_list/presenter'
    autoload :Tallier, 'pick_list/tallier'

    attr :list
    attr_accessor :parser, :presenter, :tallier

    def deliveries_for(route: nil, brand: nil)
      route.nil? ? deliveries_for_brand(brand) : deliveries_for_route(route)
    end


    def each(&block)
      list.each(&block)
    end


    def initialize
      @parser = Parser.new
      @presenter = Presenter.new
      @tallier = Tallier.new
    end


    def parse(str: string)
      parser.parse str: str
    end


    def present
      presenter.present self
    end


    def routes
      tallier.results.collect(&:route).uniq
    end


    def tally(results)
      tallier.tally results
      build_list
      results
    end


    def results
      tallier.results
    end

  private

    def build_list
      # route, brand, 1/2s, 1/4s, 1/6s, cases
      @list = {}
      routes.each do |route|
        @list[route] = results.inject({}) do |hash,delivery|

          if delivery.route == route
            hash[delivery.brand] ||= Mix.new

            case delivery.package_size
            when '1/2'
              hash[delivery.brand].half += delivery.quantity
            when '1/4'
              hash[delivery.brand].quarter += delivery.quantity
            when '1/6'
              hash[delivery.brand].sixtel += delivery.quantity
            when 'Case'
              hash[delivery.brand].kase += delivery.quantity
            else
              raise "Unknown package size #{delivery.package_size}"
            end
          end
          hash
        end
      end
    end

  end
end
