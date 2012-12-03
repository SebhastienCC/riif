module Riif::DSL
  class Trns
    HEADER_COLUMNS = [
      :trnsid,
      :trnstype,
      :date,
      :accnt,
      :name,
      :class,
      :amount,
      :docnum,
      :memo,
      :clear,
      :toprint,
      :addr1,
      :addr2,
      :addr3,
      :addr4,
      :addr5,
      :duedate,
      :terms,
      :paid,
      :shipdate
    ]

    def initialize
      @rows = []
      @current_row = []
      @start_column = 'TRNS'
      @end_column = 'ENDTRNS'
    end

    def build(&block)

      instance_eval(&block)

      output
    end

    def output
      {
        headers: [
          ["!#{@start_column}"].concat(HEADER_COLUMNS.map(&:upcase)),
          ["!SPL"].concat(Spl::HEADER_COLUMNS.map(&:upcase)),
          ["!#{@end_column}"]
        ],
          rows: @rows << [@end_column]
      }
    end

    def row(&block)
      @current_row = [@start_column]

      instance_eval(&block)

      @rows << @current_row
    end

    def spl(&block)
      Spl.new.build(&block)[:rows].each do |row|
        @rows << row
      end
    end

    def method_missing(method_name, *args, &block)
      if HEADER_COLUMNS.include?(method_name)
        @current_row[HEADER_COLUMNS.index(method_name) + 1] = args[0]
      else
        super
      end
    end
  end
end