class ActivityCatalog
  def self.all(attributes:, user:)
    new(attributes: attributes, user: user).all
  end

  def initialize(attributes:, user: user)
    @attributes = attributes
    @user = user
  end

  def all
    activities = Activity.all
    activities = activities.not_on_history
    activities = activities.joins(:user_activities).where.not(user_activities: { user: user })

    # activities = activities.where(preferred_gender: [current_user.gender, "n"])
    #
    # activities = activities.where(category: category) if category
    # activities = activities.where("preferred_age_from <= ? ", preferred_age_from).where("preferred_age_to >= ? ", preferred_age_to) if  preferred_age_from && preferred_age_to
    # activities = activities.where(location_id: location_id) if attributes[:location_id]
    # activities = activities.where(state: state) if state
    # activities = activities.where(date_from: date_from) if date_from && !date_to
    # activities = activities.where("date_from >= ? ", date_from).where("date_from <= ? ", date_to) if date_from && date_to

    activities.recent
  end

  private

  attr_reader :attributes, :user

  def category
    attributes[:category]
  end

  def location
    attributes[:location_id]
  end

  def state
    attributes[:state]
  end

  def date_from
    attributes[:date_from]
  end

  def date_to
    attributes[:date_to]
  end

  def preferred_age_from
    attributes[:preferred_age_from]
  end

  def preferred_age_to
    attributes[:preferred_age_to]
  end
end
