class Quest < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {minimum: 5, maximum: 25}

  has_many :steps, :class_name => 'Step', dependent: :destroy, inverse_of: :quest
end
