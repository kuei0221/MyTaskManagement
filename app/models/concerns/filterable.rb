module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
<<<<<<< HEAD
    def filter(params)
      results = self.where(nil)
      params.slice(*filterable_column).each do |key, value|
=======
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
        results = results.public_send("search_#{key}", value) if value.present?
      end
      results
    end
<<<<<<< HEAD

    def filterable_column
      return @filterable_column 
    end

    private
    def filterable(*args)
      #accept list of symbol & string, also array of them. if is array will be extract as follow
      args = args[0] if args.size == 1 && args[0].is_a?(Array)
      # need to be symbol for params.slice working
      args = args.map(&:to_sym)
      @filterable_column = [*args]
      #WIP:　expect to auto create scope by columns for included class
      # columns.each do |column|
      #   self.class.send(define_method "search_#{column}", ->(input){ where(column: input) })
      # end
    end

=======
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
  end

end