# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OnCallPeriod, type: :model do
  let(:params) { { number: number, start_date: start_date, end_date: end_date } }
  let(:number) { 1 }
  let(:end_date) { Time.current.beginning_of_day }
  let(:start_date) { end_date - 4.weeks }

  subject(:on_call_period) { described_class.new(params) }

  describe '.new' do
    it 'creates a new instance' do
      expect(on_call_period).to be_instance_of described_class
    end
  end

  describe '#valid' do
    shared_examples 'it is invalid' do
      it 'is not valid' do
        expect(on_call_period).not_to be_valid
      end
    end

    context 'with valid attributes' do
      it 'is valid' do
        expect(on_call_period).to be_valid
      end
    end

    context 'without a number' do
      let(:number) { nil }

      it_behaves_like 'it is invalid'
    end

    context 'the number is not integer' do
      let(:number) { 'number' }

      it_behaves_like 'it is invalid'
    end

    context 'the number already exists' do
      before do
        create(:on_call_period, number: 1,
                                start_date: start_date,
                                end_date: end_date)
      end

      it_behaves_like 'it is invalid'
    end

    context 'without a start date' do
      let(:start_date) { nil }

      it_behaves_like 'it is invalid'
    end

    context 'without a end date' do
      let(:start_date) { nil }

      it_behaves_like 'it is invalid'
    end

    context 'end date earlier than start date' do
      let(:start_date) { end_date + 4.weeks }

      it_behaves_like 'it is invalid'
    end
  end

  describe 'association' do
    let(:member) { create(:member) }
    let(:on_call_period) { create(:on_call_period, number: 1, start_date: 1.month.ago, end_date: Time.current) }
    let(:on_call_units) do
      [create_list(:on_call_unit, 2, start_date: 1.month.ago, end_date: 1.month.ago.tomorrow,
                                     member: member, on_call_period: on_call_period)]
    end

    it 'has may on call units' do
      on_call_period.on_call_units.each.with_index do |unit, i|
        expect(unit).to be eq(on_call_units[i])
      end
    end
  end
end
