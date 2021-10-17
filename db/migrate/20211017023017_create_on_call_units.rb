class CreateOnCallUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :on_call_units do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.references :member, null: false, foreign_key: true
      t.references :on_call_period, null: false, foreign_key: true

      t.timestamps
    end
  end
end
