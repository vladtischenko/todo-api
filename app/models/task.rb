# frozen_string_literal: true

class Task < ApplicationRecord
  acts_as_taggable
  belongs_to :board, dependent: :destroy, counter_cache: true
  enum status: {
    pending:     0,
    in_progress: 1,
    done:        2
  }
end
