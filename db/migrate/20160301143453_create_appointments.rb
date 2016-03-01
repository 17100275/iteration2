class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :Date
      t.string :Valid

      t.timestamps null: false
    end
  end
end
