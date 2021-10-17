# frozen_string_literal: true

class OnCallPeriodsController < ApplicationController
  def index
    current_on_call_member
  end

  def new
    @on_call_period = OnCallPeriod.new
  end

  def create # rubocop:disable Metrics/AbcSize
    
    return redirect_to new_on_call_period if period_params[:start_date].nil?

    start_date = period_params[:start_date].to_date.beginning_of_day
    end_date = (start_date + members.count.weeks) - 1.day

    ActiveRecord::Base.transaction do
      period = OnCallPeriod.create(start_date: start_date.to_s, end_date: end_date.to_s)

      members.each do |member|
        end_date = (start_date + 6.days).end_of_day
        OnCallUnit.create(on_call_period: period, member: member, start_date: start_date.to_s, end_date: end_date.to_s)
        start_date += 1.week
      end
    end

    redirect_to root_path
  end

  private

  def current_on_call_member
    time_now = Time.now.to_s
    @current_on_call_member ||= OnCallUnit.find_by('start_date < ? AND end_date > ?', time_now, time_now)&.member
  end

  def members
    @members ||= Member.all
  end

  def period_params
    params.require(:on_call_period).permit(:start_date)
  end
end
