class Record < ActiveRecord::Base
    validates :Prescriptions, presence: true
    validates :Symptoms, presence: true

    belongs_to :user
end
