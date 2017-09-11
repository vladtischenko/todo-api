class Task < ActiveRecord::Base
  acts_as_taggable
  belongs_to :board
  enum status: {
    pending:     0,
    in_progress: 1,
    done:        2
  }
end
