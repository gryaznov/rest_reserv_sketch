# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'instance methods' do
    let(:date) { Date.new(2020, 6, 6) }
    let(:restaurant) { create :restaurant, opening_time: '11:30', closing_time: '02:00' }

    it '#opens_at' do
      expect(restaurant.opens_at(date)).to eq 1591432200 # 2020-04-06 11:30:00
    end

    it '#closes_at' do
      expect(restaurant.closes_at(date)).to eq 1591484400 # 2020-04-07 02:00:00 (because it works after midnight)
    end
  end
end
