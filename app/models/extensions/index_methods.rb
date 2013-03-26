module Extensions
  module IndexMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def search_by_terms(search_terms)
        all.search(search_terms)
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
        join_list = []

        fields.each do |field|
          if field.is_a?(Hash)
            join_list << field[:join] unless join_list.include? field[:join]
            table_name = field[:join].to_s.pluralize
            column = field[:column]
          else
            table_name = self.table_name
            column = field
          end

          if query.present?
            query += " or "
          end

          query += "lower(#{table_name}.#{column}) like ?"
          args += [term]
        end

        joins(join_list).where(query, *args)
      end
    end
  end
end
