module NRB
  class PickList
    class Presenter

      def present(pick_list)
        if pick_list.results.empty?
          puts 'Nothing to present'
          return
        end
        pick_list.sort.each do |route,brands|
          printf header_str, route, "1/2", "1/4", "1/6", "Case"
          brands.sort.each do |brand,mix|
            next if mix.empty?
            printf line_str, brand, mix.half, mix.quarter, mix.sixtel, mix.kase
          end
          puts
        end
      end

    private

      def format_str
        "  %3s  %3s  %3s  %4s\n"
      end


      def header_str
        "%-25s" + format_str
      end


      def line_str
        "%25s" + format_str
      end

    end
  end
end
