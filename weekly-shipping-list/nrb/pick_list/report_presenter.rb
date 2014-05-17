module NRB
  class PickList
    class ReportPresenter

      def initialize(pick_list: [])
        @pick_list = pick_list
        accumulate_results
      end


      def present
        if @pick_list.empty?
          puts 'Nothing to present'
          return
        end
        # Route
        # Brand  1/2  1/4  1/6  Case
      end

    private

      def accumulate_results
        @routes = { }
        @pick_list.each do |result|
        end
      end

    end
  end
end
