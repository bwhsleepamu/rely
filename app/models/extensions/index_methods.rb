module Extensions
  module IndexMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def search_by_terms(search_terms)
        #search_scope = scoped
        #search_terms.each{|search_term| search_scope = search_scope.search(search_term) }
        #
        #search_scope

        scoped.search(search_terms)
      end

      def set_order(params, default_column)
        (params_column, params_direction) = params.to_s.strip.downcase.split(' ')
        direction = (params_direction == 'desc' ? 'desc' : 'asc')
        order_column = column_names.collect{|column_name| "#{column_name}"}.include?(params_column) ? params_column : default_column

        order_by = "#{table_name}.#{order_column} #{direction}"

        order(order_by)
      end

      def scrub_order(order, default_column)
        (params_column, params_direction) = params.to_s.strip.downcase.split(' ')
        direction = (params_direction == 'desc' ? 'desc' : 'asc')
        order_column = column_names.collect{|column_name| "#{column_name}"}.include?(params_column) ? params_column : default_column


      end

      def search_scope(fields, term)
        term = "%#{term.downcase.split(' ').join('%')}%"

        args = []
        query = " "

        fields.each do |field|
          if query.present?
            query += " or "
          end

          query += "lower(#{field}) like ?"
          args += [term]
        end

        where(query, *args)
      end
    end
  end
end