# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member, type: :model do
  describe '.new' do
    subject(:member) { described_class.new(params) }

    let(:params) { { name: name } }
    let(:name) { 'test' }

    it 'creates a new instance' do
      expect(member).to be_instance_of Member
    end
  end

  describe '#valid' do
    subject(:member) { described_class.new(params) }

    let(:params) { { name: name } }

    context 'with valid attributes' do
      let(:name) { 'John Doe' }

      it 'is valid' do
        expect(member).to be_valid
      end
    end

    context 'without a name' do
      let(:name) { nil }

      it 'is not valid' do
        expect(member).not_to be_valid
      end
    end
  end

  describe 'association' do
    let(:member) { create(:member) }
    let(:period) { create(:on_call_period, number: 1, start_date: 1.month.ago, end_date: Time.current) }
    let(:unit) do
      [create(:on_call_unit, start_date: 1.month.ago, end_date: 1.month.ago.tomorrow,
                             member: member, on_call_period: period)]
    end

    it 'has on call units' do
      expect(member.on_call_units).to eq unit
    end
  end
end
