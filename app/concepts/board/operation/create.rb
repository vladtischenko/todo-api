class Board::Create < Trailblazer::Operation
  step Model( Board, :new )
  step :assign_current_user!
  step Policy::Pundit( BoardPolicy, :create? )
  step Contract::Build( constant: Board::Contract::Create )
  step Contract::Validate()
  # failure  :log_error!
  step Contract::Persist()

  # def log_error!(options)
  #   binding.pry
  #   puts 'fail'
  # end

  def assign_current_user!(options)
    options["model"].user_id = options["current_user"].id
  end
end
