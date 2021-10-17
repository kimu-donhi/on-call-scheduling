class AddColumnsToOnCallPeriods < ActiveRecord::Migration[6.1]
  def change
    add_column :on_call_periods, :start_date, :datetime,
    add_column :on_call_periods, :end_date, :datetime
  end
end
