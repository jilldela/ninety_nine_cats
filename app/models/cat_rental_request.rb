class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: ["APPROVED", "DENIED", "PENDING"]
  validate :does_not_overlap_approved_request

  belongs_to :cat,
    dependent: :destroy,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: :Cat

  def overlapping_requests
    cat = Cat.find_by(id: self.cat_id)
    requests = cat.cat_rental_requests
    requests.where.not('(start_date > ? AND end_date > ?) OR
                        (start_date < ? AND end_date < ?) AND
                        id <> ?',
                        end_date, end_date, start_date, start_date, self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def approve!
    self.status = "APPROVED"
    self.save

    pending = overlapping_requests.where(status: "PENDING")
    pending.each do |request|
      request.deny!
    end
  end

  def deny!
    self.status = "DENIED"
  end

  private

  def does_not_overlap_approved_request
    if CatRentalRequest.exists?(self.overlapping_approved_requests)
      errors[:base] << "This cat is taken"
    end
  end
end
