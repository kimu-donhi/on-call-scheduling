# frozen_string_literal: true

class OnCallPeriodsController < ApplicationController
  def index
    @on_call_period = OnCallPeriod.new
    current_on_call_member
    on_call_schedules
  end

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    start_date = new_period_start_date
    end_date = (start_date + members.count.weeks) - 1.day

    ActiveRecord::Base.transaction do
      period = OnCallPeriod.create(start_date: start_date.to_s, end_date: end_date.to_s)

      members.each do |member|
        end_date = (start_date + 6.days).end_of_day
        OnCallUnit.create(on_call_period: period, member: member, start_date: start_date.to_s, end_date: end_date.to_s)
        start_date += 1.week
      end

      flash[:notice] = "Period #{period.id}(#{period.to_date}) created successfully."
    end

    redirect_to root_path
  end

  private

  def current_on_call_member
    time_now = Time.now.to_s
    @current_on_call_member ||= OnCallUnit.find_by('start_date < ? AND end_date > ?', time_now, time_now)&.member
  end

  def on_call_schedules
    @schedules = OnCallUnit.where('start_date >= ? AND start_date <= ?',
                                  search_date.beginning_of_month,
                                  search_date.end_of_month).order(start_date: :asc)
  end

  def search_params
    params.permit(:search_date)
  end

  def search_date
    year = search_params.present? ? search_params['search_date(1i)'].to_i : Time.now.year
    month = search_params.present? ? search_params['search_date(2i)'].to_i : Time.now.month

    DateTime.new(year, month, 1)
  end

  def members
    @members ||= Member.all
  end

  def new_period_start_date
    return Time.current.beginning_of_day if OnCallPeriod.count.zero?

    (OnCallPeriod.last.end_date.to_date + 1.day).beginning_of_day
  end
end
