class Step < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 50}
  validates :answer, presence: true, length: {minimum: 5, maximum: 50}
  validates :body, presence: true, length: {minimum: 5, maximum: 300}
  validates :step_number, presence: true
  validates :points, presence: true
  validates :step_number, uniqueness: { scope: :quest_id }

  belongs_to :quest, class_name: 'Quest', foreign_key: :quest_id
end
