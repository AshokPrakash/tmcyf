class AddEmergencyContactAndDaysAvailableToRetreatRegistrations < ActiveRecord::Migration
  def change
    change_table :retreat_registrations do |t|
      t.string :emergency_contact
      t.string :emergency_phone
      t.string :emergency_relation
      t.string :insurance_provider
      t.string :insurance_policy_number

      # dates attending
      t.date :start_date
      t.date :end_date
    end
  end
end
