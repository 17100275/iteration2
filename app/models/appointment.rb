class Appointment < ActiveRecord::Base
    validates :Date, presence: true

    belongs_to :user
end
