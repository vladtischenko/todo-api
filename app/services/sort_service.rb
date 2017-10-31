class SortService
  attr_accessor :errors, :status
  attr_writer :query

  def initialize(collection, sort_params, allowed_fields)
    @collection     = collection
    @sort_params    = sort_params.split(',')
    @allowed_fields = allowed_fields
    @query          = collection
    self.errors     = []
    self.status     = :ok

    check_sucess
  end

  def sorted_collection
    ok? ? make_sort : @collection
  end

  def ok?
    status == :ok
  end

  private

  def check_sucess
    if sort_rules.size != @sort_params.size
      return add_error(I18n.t('errors.messages.invalid_sorting_params'))
    end

    make_sort.first
  rescue ActiveRecord::ConfigurationError
    add_error I18n.t('errors.messages.invalid_sorting_association')
  rescue ActiveRecord::StatementInvalid
    add_error I18n.t('errors.messages.invalid_sorting_params')
  end

  def make_sort
    @sort_result ||= begin
      sort_rules.each do |rule|
        sort_element, order = rule.first

        if relation?(sort_element)
          add_relation_order(sort_element, order)
        else
          add_to_order_list(sort_element, order, collection_table)
        end
      end

      if joins_associations.present?
        @query = @query.eager_load(*joins_associations.uniq)
      end

      @query.order(orders.join(', '))
    end
  end

  def sort_rules
    @sort_rules ||= begin
      sort_rules = @sort_params.map do |field|
        order = field.slice!(/^-/) ? :desc : :asc
        { field => order }
      end

      sort_rules.select { |rule| @allowed_fields.include?(rule.keys.first) }
    end
  end

  def add_relation_order(sort_relation, order)
    elements = sort_relation.split('.')

    table_name, sort_field = elements[-2..-1]

    add_to_order_list(sort_field, order, table_name)

    joins_associations.push(make_join_hash(elements[0..-2]))
  end

  def joins_associations
    @joins_associations ||= []
  end

  def make_join_hash(relations)
    association = relations.first.to_sym
    join_name   = association

    return join_name if relations.size == 1
    { join_name => make_join_hash(relations[1..-1]) }
  end

  def add_to_order_list(field, order, table_name)
    field = field.underscore

    order_line = "#{table_name.pluralize}.#{field} #{order}"
    orders.push(order_line)
  end

  def relation?(field)
    field.include?('.')
  end

  def orders
    @orders ||= []
  end

  def add_error(text)
    self.status = :bad_request
    errors << text
  end

  def collection_table
    @collection_table ||= @collection.klass.table_name
  end
end
