class Task < ApplicationRecord
  has_many :sub_tasks, dependent: :destroy
  belongs_to :user

  validates :description, presence: true

  scope :completed, ->  { where(completed: true) }
  scope :pending,   ->  { where(completed: false) }
  scope :ordered,   ->  { order(due_date: :asc) }
  scope :past_due,  ->  { where("due_date < ?", Date.today) }
  scope :due_soon,  ->  {
                          where("due_date >= ? and due_date < ?",
                          Date.today, 1.week.from_now.to_date)
                        }
  scope :due_later, ->  { where("due_date >= ?", 1.week.from_now.to_date) }
  scope :not_due,   ->  { where(due_date: nil) }
  scope :search,    ->  (term){ where("description ilike ?", "%#{term}%") }
  scope :between,   ->  (start_date, end_date){
                          where("due_date >= ? and due_date <= ?",
                          start_date, end_date)
                        }

  def due_date_class
    if due_date.nil?
      "due_date"
    elsif due_date < Date.today
      "due_date badge badge-danger"
    elsif due_date < 1.week.from_now.to_date
      "due_date badge badge-warning"
    else
      "due_date badge badge-success"
    end
  end

  def as_json(options={})
    {
      id:             id,
      description:    description,
      completed:      completed,
      due_date:       due_date&.strftime('%-m/%-d/%y'),
      location:       "/tasks/#{id}/sub_tasks",
      due_date_class: due_date_class
    }
  end
end
