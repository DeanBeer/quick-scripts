module NRB
  class PickList
    class Presenter

      def present(pick_list)
        if pick_list.results.empty?
          puts 'Nothing to present'
          return
        end
        pick_list.sort.each do |route,brands|
          printf "%-35s  %3s  %3s  %3s  %4s\n", route, "1/2", "1/4", "1/6", "Case"
          brands.sort.each do |brand,mix|
            next if mix.empty?
            printf "%35s  %3s  %3s  %3s  %4s\n", brand, mix.half, mix.quarter, mix.sixtel, mix.kase
          end
          puts
        end
      end

    end
  end
end
