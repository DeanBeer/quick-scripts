$:.unshift(File.dirname(__FILE__))  # UNHACKME
module NRB
  class PickList
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

  end
end
