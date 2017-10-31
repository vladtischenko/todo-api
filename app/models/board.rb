# frozen_string_literal: true

class Board < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :tasks
end
