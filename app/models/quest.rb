class Quest < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}

  scope :published, -> { where(is_published: true) }

  has_many :steps, -> { order(step_number: :asc) }, :class_name => 'Step', dependent: :destroy, inverse_of: :quest

  def total_score
    return 0 if steps.blank?
    steps.sum(:points)
  end

  def steps_up_to(step_number)
    steps.where("steps.step_number <= ?", step_number)
  end
end
