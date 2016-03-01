class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.text :Prescriptions
      t.text :Symptoms

      t.integer :Day
      t.integer :Month
      t.integer :Year

      # t.datetime :release_date

      t.timestamps null: false
    end
  end
end
