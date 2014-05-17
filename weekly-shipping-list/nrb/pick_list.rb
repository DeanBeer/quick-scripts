$:.unshift(File.dirname(__FILE__))  # UNHACKME
module NRB
  class PickList

    autoload :Delivery, 'pick_list/delivery'
    autoload :ProductNameParser, 'pick_list/product_name_parser'
    autoload :ReportParser, 'pick_list/report_parser'
    autoload :ReportPresenter, 'pick_list/report_presenter'
    autoload :ReportTallier, 'pick_list/report_tallier'

    attr_reader :routes

    def initialize(report: [])
      @report = report
      @routes = @report.collect(&:route).uniq
    end

  end
end
