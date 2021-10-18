# frozen_string_literal: true

class OnCallUnitsController < ApplicationController
  def edit
    @unit = OnCallUnit.find(edit_params[:id])
    @other_units = OnCallUnit.where(on_call_period_id: @unit.on_call_period_id)
                             .order(start_date: :asc)
                             .reject { |unit| unit.member_id == @unit.member_id }
  end

  def update # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    init_units

    ActiveRecord::Base.transaction do
      selected_member_id = @selected_unit.member_id
      @selected_unit.member_id = @target_unit.member_id
      @selected_unit.save!

      @target_unit.member_id = selected_member_id
      @target_unit.save!
    end

    flash[:success] = 'Schedule swapped successfully.'
    redirect_to root_path
  rescue StandardError => e
    Rails.logger.error e
    flash[:error] = 'Invalid parameters passed.'
    redirect_back(fallback_location: root_path)
  end

  private

  def edit_params
    params.permit(:id)
  end

  def update_params
    params.permit(:id, :selected_unit_id)
  end

  def init_units
    @target_unit = OnCallUnit.find(update_params[:id])
    @selected_unit = OnCallUnit.find(update_params[:selected_unit_id])
  end
end
