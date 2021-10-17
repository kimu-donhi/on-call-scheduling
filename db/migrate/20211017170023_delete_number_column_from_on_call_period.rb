class DeleteNumberColumnFromOnCallPeriod < ActiveRecord::Migration[6.1]
  def change
    remove_column :on_call_periods, :number, :integer
  end
end
