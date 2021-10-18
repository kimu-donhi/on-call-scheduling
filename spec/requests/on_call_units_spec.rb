# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OnCallUnits', type: :request do
  let!(:members) { FactoryBot.create_list(:member, 10) }
  let(:start_date) { Time.current.beginning_of_day }
  let(:end_date) { (start_date + members.count.weeks) - 1.day }
  let!(:period) { FactoryBot.create(:on_call_period, start_date: start_date, end_date: end_date) }
  let!(:units) { OnCallUnit.where(on_call_period: period).order(start_date: :asc) }

  before do
    start_date = Time.current.beginning_of_day
    members.each do |member|
      end_date = (start_date + 6.days).end_of_day
      FactoryBot.create(:on_call_unit, member: member, on_call_period: period,
                                       start_date: start_date, end_date: end_date)
      start_date += 1.week
    end
  end

  describe 'GET #edit' do
    subject(:edit) { get edit_on_call_unit_path(units.first.id) }

    it 'renders the edit template' do
      edit
      expect(response).to render_template(:edit)
    end

    it 'returns a 200 OK http status' do
      edit
      expect(response).to have_http_status(200)
    end

    it 'shows page title' do
      edit
      expect(response.body).to include 'Swap schedule'
    end
  end

  describe 'POST #update' do
    let(:target_id) { units.first.id }
    let(:params) { { selected_unit_id: units.second.id } }

    subject(:update) { patch on_call_unit_path(target_id), params: params }

    context 'with valid parameters' do
      it 'is redirected to root_path' do
        update
        expect(response).to redirect_to root_path
      end

      it 'returns a 302 redirect http status' do
        update
        expect(response).to have_http_status(:redirect)
      end

      it 'has success message' do
        update
        expect(flash[:success]).to be_truthy
      end
    end

    context 'with not valid parameters' do
      shared_examples 'fail to update' do
        it 'is redirected to edit on call unit page' do
          update
          expect(response).to redirect_to edit_on_call_unit_path(target_id)
        end

        it 'returns a 302 redirect http status' do
          update
          expect(response).to have_http_status(:redirect)
        end

        it 'has error message' do
          update
          expect(flash[:error]).to be_truthy
        end
      end

      context 'without a target id' do
        let(:target_id) { nil }

        it 'occurs error' do
          expect { update }.to raise_error ActionController::UrlGenerationError
        end
      end

      context 'without a selected unit id' do
        let(:params) { { selected_unit_id: nil } }

        it_behaves_like 'fail to update'
      end

      context 'with selected unit id which does not integer' do
        let(:params) { { selected_unit_id: 'selected_unit_id' } }

        it_behaves_like 'fail to update'
      end

      context 'with selected unit id which does not exist' do
        let(:params) { { selected_unit_id: (OnCallUnit.last.id + 1) } }

        it_behaves_like 'fail to update'
      end
    end
  end
end
