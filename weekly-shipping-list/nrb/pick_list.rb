$:.unshift(File.dirname(__FILE__))  # UNHACKME
module NRB
  class PickList

    include Enumerable

    autoload :Delivery, 'pick_list/delivery'
    autoload :ProductNameParser, 'pick_list/product_name_parser'
    autoload :ReportParser, 'pick_list/report_parser'
    autoload :ReportPresenter, 'pick_list/report_presenter'
    autoload :ReportTallier, 'pick_list/report_tallier'

    attr :list
    attr_accessor :parser, :presenter, :tallier

    def each(&block)
      list.each(&block)
    end

    def initialize
      @parser = ReportParser.new
      @presenter = ReportPresenter.new
      @tallier = ReportTallier.new
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

    class Mix < Struct.new(:half, :quarter, :sixtel, :kase)

      def initialize(half=0, quarter=0, sixtel=0, kase=0)
        self.half = half
        self.quarter = quarter
        self.sixtel = sixtel
        self.kase = kase
      end

      def empty?
        half + quarter + sixtel + kase == 0
      end

    end


    def build_list
      # route, brand, 1/2s, 1/4s, 1/6s, cases
      @list = {}
      routes.each do |route|
        @list[route] = results.inject({}) do |hash,delivery|
          hash[delivery.brand] ||= Mix.new

          case delivery.package_size
          when '1/2'
            hash[delivery.brand].half += delivery.quantity
          when '1/4'
            hash[delivery.brand].quarter += delivery.quantity
          when '1/6'
            hash[delivery.brand].sixtel += delivery.quantity
          when 'case'
            hash[delivery.brand].kase += delivery.quantity
          end
          hash
        end
      end
    end

  end
end
