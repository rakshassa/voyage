class Teamquest < ApplicationRecord
  validates :team_id, presence: true
  validates :quest_id, presence: true
  validates :quest_status, presence: true
  validates :answer_seed, presence: true, length: {minimum: 5, maximum: 25}

  enum quest_status: {
    unavailable: 1,
    not_started: 2,
    in_progress: 3
  }
end
