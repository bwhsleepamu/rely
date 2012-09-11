module Extensions
  module IndexMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def search_by_terms(search_terms)
        search_scope = scoped
        search_terms.each{|search_term| search_scope = search_scope.search(search_term) }

        search_scope
      end

      def set_order(params, default_column)
        order_column = column_names.collect{|column_name| "#{table_name}.#{column_name}"}.include?(params.to_s.split(' ').first) ? params : "#{table_name}.#{default_column}"
        order(order_column)
      end
    end
  end
end