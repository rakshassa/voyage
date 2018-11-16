class Step < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 50}
  validates :answer, presence: true, length: {minimum: 5, maximum: 50}
  validates :body, presence: true, length: {minimum: 5, maximum: 300}
  validates :step_number, presence: true
  validates :points, presence: true
  validates :step_number, uniqueness: { scope: :quest_id }

  # Returns an array if hashes:  [{ quest_id: 1, max_step: 3 }, { quest_id: 2, max_step: 2 }]
  # scope :last_steps, -> { select('quest_id, MAX(step_number) AS max_step').group(:quest_id) }

  belongs_to :quest, class_name: 'Quest', foreign_key: :quest_id

  # def self.print_last_steps
  #   Step.last_steps.each do |x|
  #     print "Quest ID: " + x.quest_id.to_s + " Last Step: " + x.max_step.to_s + "\n"
  #   end
  # end

  def is_last_step
    quest.last_step_number == step_number
  end
end

