# frozen_string_literal: true

class Board < ApplicationRecord
  belongs_to :user, dependent: :destroy, counter_cache: true
  has_many :tasks
end
