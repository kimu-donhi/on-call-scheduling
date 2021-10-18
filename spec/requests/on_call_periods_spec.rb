# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OnCallPeriods', type: :request do
  let!(:members) { FactoryBot.create_list(:member, 10) }

  describe 'GET #index' do
    subject(:index) { get root_path }

    it 'renders the index page' do
      index
      expect(response).to render_template(:index)
    end

    it 'returns a 200 OK http status' do
      index
      expect(response).to have_http_status(:success)
    end

    it 'shows page title' do
      index
      expect(response.body).to include 'On-call scheduling'
    end
  end

  describe 'POST #create' do
    subject(:create) { post on_call_period_path }

    shared_examples 'on call models created' do
      it 'creates a new on call period' do
        expect { create }.to change { OnCallPeriod.count }.by(1)
      end

      it 'creates a new on call units' do
        expect { create }.to change { OnCallUnit.count }.by(members.count)
      end

      it 'has end date which is members number weeks later than start date' do
        create
        period = OnCallPeriod.first
        expect(period.end_date).to eq (period.start_date + members.count.weeks) - 1.day
      end
    end

    it 'is redirected to root_path' do
      create
      expect(response).to redirect_to root_path
    end

    it 'returns a 302 redirect http status' do
      create
      expect(response).to have_http_status(:redirect)
    end

    it_behaves_like 'on call models created'

    context 'one or more periods already exist' do
      let(:start_date) { Time.current.beginning_of_day }
      let(:end_date) { (start_date + members.count.weeks) - 1.day }
      let!(:prev_period) { FactoryBot.create(:on_call_period, start_date: start_date, end_date: end_date) }
      let(:prev_units) { OnCallUnit.where(on_call_period: period).order(start_date: :asc) }

      before do
        start_date = Time.current.beginning_of_day
        members.each do |member|
          end_date = (start_date + 6.days).end_of_day
          FactoryBot.create(:on_call_unit, member: member, on_call_period: prev_period,
                                           start_date: start_date, end_date: end_date)
          start_date += 1.week
        end
      end

      it_behaves_like 'on call models created'

      it 'has start_date which 1 day later than end_date of previous period' do
        create
        new_period = OnCallPeriod.last
        expect(new_period.start_date).to eq prev_period.end_date + 1.day
      end
    end
  end
end
