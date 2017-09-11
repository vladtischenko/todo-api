# frozen_string_literal: true

class Board < ApplicationRecord
  belongs_to :user
  has_many :tasks
end
