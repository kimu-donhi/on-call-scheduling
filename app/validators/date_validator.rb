# frozen_string_literal: true

class DateValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.nil? || record.end_date.nil?

    record.errors.add :end_date, 'must be later than start date.' if record.start_date >= record.end_date
  end
end
