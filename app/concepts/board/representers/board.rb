require 'roar/json/json_api'

class BoardRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :boards
  # include Roar::Representer::Feature::Errors

  # top-level link.
  # link :self, toplevel: true do
  #   "//boards"
  # end

  attributes do
    property :name
  end

  # resource object links
  # link(:self) { "http://#{represented.class}/#{represented.id}" }

  # relationships
  # has_one :author, class: Author, populator: ::Representable::FindOrInstantiate do # populator is for parsing, only.
  #   type :authors

  #   attributes do
  #     property :email
  #   end

  #   link(:self) { "http://authors/#{represented.id}" }
  # end

  # has_many :comments, class: Comment, decorator: CommentDecorator
end
