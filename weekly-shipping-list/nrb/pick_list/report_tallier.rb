module NRB
  class PickList
    class ReportTallier

      attr_reader :results

      def initialize
        @results = []
      end


      def tally(line_items=[])
        # Not thread-safe !hah!
        line_items.each do |item|
          pos = in_results(item)
          if pos == -1
           @results << item
          else
            @results[pos] += item
          end
        end
        @results
      end

    private

      def in_results(item)
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
