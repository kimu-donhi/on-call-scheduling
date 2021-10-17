# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OnCallUnit, type: :model do
  let(:members) { create_list(:member, 4) }
  let(:beginning_of_today) { Time.current.beginning_of_day }
  let(:on_call_period) do
    create(:on_call_period, start_date: (beginning_of_today - 4.weeks),
                            end_date: beginning_of_today)
  end
  let(:start_date) { beginning_of_today - 1.week }
  let(:end_date) { beginning_of_today }
  let(:params) do
    { start_date: start_date,
      end_date: end_date,
      member: members.first,
      on_call_period: on_call_period }
  end

  subject(:on_call_unit) { described_class.new(params) }

  describe '.new' do
    it 'creates a new instance' do
      expect(on_call_unit).to be_instance_of OnCallUnit
    end
  end

  describe '#valid' do
    shared_examples 'it is invalid' do
      it 'is not valid' do
        expect(on_call_unit).not_to be_valid
      end
    end

    context 'with valid attributes' do
      it 'is valid' do
        expect(on_call_unit).to be_valid
      end
    end

    context 'without a start date' do
      let(:start_date) { nil }

      it_behaves_like 'it is invalid'
    end

    context 'without a end date' do
      let(:end_date) { nil }

      it_behaves_like 'it is invalid'
    end

    context 'end date earlier than start date' do
      let(:start_date) { Time.current.beginning_of_day + 4.weeks }

      it_behaves_like 'it is invalid'
    end
  end

  describe 'association' do
    it 'belongs to the member' do
      expect(on_call_unit.member).to eq(members.first)
    end

    it 'belongs to the period' do
      expect(on_call_unit.on_call_period).to eq(on_call_period)
    end
  end
end
