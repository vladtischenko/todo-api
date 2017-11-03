class BoardQuery
  def initialize(boards, params)
    @boards = boards
    @params = params
  end

  def call
    @boards = filter_name
    @boards = filter_created_from_date
    @boards = filter_created_to_date
    @boards = filter_updated_from_date
    @boards = filter_updated_to_date
    @boards
  end

  private

  def filter_name
    return @boards if @params[:name].blank?
    @boards.where('boards.name LIKE :name', name: "%#{@params[:name]}%")
  end

  def filter_created_from_date
    return @boards if @params[:created_from_date].blank?
    @boards.where(Arel::Nodes::NamedFunction.new('DATE', [Board.arel_table[:created_at]]).gteq(@params[:created_from_date]))
  end

  def filter_created_to_date
    return @boards if @params[:created_to_date].blank?
    @boards.where(Arel::Nodes::NamedFunction.new('DATE', [Board.arel_table[:created_at]]).lteq(@params[:created_to_date]))
  end

  def filter_updated_from_date
    return @boards if @params[:updated_from_date].blank?
    @boards.where(Arel::Nodes::NamedFunction.new('DATE', [Board.arel_table[:updated_at]]).gteq(@params[:updated_from_date]))
  end

  def filter_updated_to_date
    return @boards if @params[:updated_to_date].blank?
    @boards.where(Arel::Nodes::NamedFunction.new('DATE', [Board.arel_table[:updated_at]]).lteq(@params[:updated_to_date]))
  end
end
