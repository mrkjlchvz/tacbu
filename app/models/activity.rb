class Activity < ActiveRecord::Base
  belongs_to :location
  belongs_to :category

  has_many :user_activities, dependent: :destroy
  has_many :members, through: :user_activities, class_name:"User", source: :user

  has_many :joined_user_activities, -> { where(role: "joiner").order(created_at: :asc)}, class_name: "UserActivity"
  has_many :joiners, through: :joined_user_activities, class_name:"User", source: :user

  has_many :organized_user_activities, -> { where(role: "organizer")}, class_name: "UserActivity"
  has_many :owners, through: :organized_user_activities, class_name:"User", source: :user

  validates :name, presence: true

  after_initialize :set_initial_state

  def self.recent
    order(created_at: :desc)
  end

  def self.on_history
    where(state: [:cancelled, :completed])
  end

  def self.booked
    where(state: :booked)
  end

  def self.not_on_history
    where.not(state: [:cancelled, :completed])
  end

  state_machine :state, initial: :pending do
    event :book do
      transition any => :booked
    end

    event :cancel do
      transition any => :cancelled
    end

    event :complete do
      transition any => :completed
    end
  end

  def organizer
    user_activity = user_activities.organizers.last
    user_activity.try(:user)
  end

  def next_joiner
    self.joiners.first
  end

  private

  def set_initial_state
    self.state ||= :pending
  end

end
