class Cat < ApplicationRecord
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: ["purple", "green", "orange", "yellow"]
  validates :sex, inclusion: ["M", "F"]

  COLORS = ["purple", "green", "orange", "yellow"]

  has_many :cat_rental_requests,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: :CatRentalRequest

  def age
    @age ||= Time.now.year - birth_date.year
  end

end
