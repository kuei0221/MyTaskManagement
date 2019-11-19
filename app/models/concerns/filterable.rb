module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(params)
      results = self.where(nil)
      params.slice(*filterable_column).each do |key, value|
        results = results.public_send("search_#{key}", value) if value.present?
      end
      results
    end

    def filterable_column
      return @filterable_column 
    end

    private
    def filterable(*args)
      #accept list of symbol & string, also array of them. if is array will be extract as follow
      args = args[0] if args.size == 1 && args[0].is_a?(Array)
      # need to be symbol for params.slice working
      args.map(&:to_sym)
      @filterable_column = [*args]
      #WIP:　expect to auto create scope by columns for included class
      # columns.each do |column|
      #   self.class.send(define_method "search_#{column}", ->(input){ where(column: input) })
      # end
    end

  end

end