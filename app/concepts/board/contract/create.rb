module Board::Contract
  class Create < Reform::Form
    property :name
    property :user

    validates :name, length: 2..33
    validates :name, :user, presence: true
  end
end
