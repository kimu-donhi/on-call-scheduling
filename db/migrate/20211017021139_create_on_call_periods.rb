class CreateOnCallPeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :on_call_periods do |t|
      t.integer :number, null: false, unique: true

      t.timestamps
    end
  end
end
