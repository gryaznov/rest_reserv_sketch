# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    let(:user) { create :user }
    let(:restaurant) { create :restaurant, opening_time: '11:30', closing_time: '02:00' }
    let(:table) { create :table, restaurant: restaurant }
    let(:table2) { create :table, number: 22, restaurant: restaurant }
    let(:date) { Date.new(2020, 6, 6)  }
    let(:reservation) { build :reservation, user: user, table: table, date: date }

    context 'overlapping' do
      context "restaurant's working schedule" do
        context 'valid' do
          # 1591443000 is 2020-06-06 11:30:00
          # 1591495200 is 2020-06-07 02:00:00
          it 'within schedule is ok' do
            reservation.from = restaurant.opens_at(date) + Reservation::STEP
            reservation.till = restaurant.closes_at(date) - Reservation::STEP
            expect(reservation).to be_valid
          end

          it 'starts right at the opening time is ok' do
            reservation.from = restaurant.opens_at(date)
            reservation.till = restaurant.closes_at(date) - Reservation::STEP
            expect(reservation).to be_valid
          end

          it 'finish right at the closing time is ok' do
            reservation.from = restaurant.opens_at(date) + Reservation::STEP
            reservation.till = restaurant.closes_at(date)
            expect(reservation).to be_valid
          end
        end

        context 'invalid' do
          it 'before schedule' do
            reservation.from = restaurant.opens_at(date) - Reservation::STEP
            reservation.till = restaurant.opens_at(date) + Reservation::STEP
            expect(reservation).not_to be_valid
          end

          it 'after schedule' do
            reservation.from = restaurant.closes_at(date)
            reservation.till = restaurant.closes_at(date) + Reservation::STEP
            expect(reservation).not_to be_valid
          end
        end
      end

      context 'table' do
        # 1591446600 is 2020-06-06 12:30:00
        # 1591450200 is 2020-06-06 13:30:00
        let!(:other) { create :reservation, table: table, user: user, from: 1591446600, till: 1591450200, date: reservation.date }

        context 'valid' do
          it 'before another reservation is ok' do
            reservation.from = other.from - Reservation::STEP
            reservation.till = other.from
            expect(reservation).to be_valid
          end

          it 'after another reservation is ok' do
            reservation.from = other.till
            reservation.till = other.till + Reservation::STEP
            expect(reservation).to be_valid
          end

          it 'with reservation for another table is ok' do
            Reservation.delete_all
            create :reservation, table: table2, user: user, from: 1591446600, till: 1591450200

            reservation.from = 1591446600
            reservation.till = 1591450200
            expect(reservation).to be_valid
          end
        end

        context 'invalid' do
          it '1:1 overlap' do
            reservation.from = other.from
            reservation.till = other.till
            expect(reservation).not_to be_valid
          end

          it 'overlap earlier' do
            reservation.from = other.from - Reservation::STEP
            reservation.till = other.till
            expect(reservation).not_to be_valid
          end

          it 'overlap within' do
            reservation.from = other.from + Reservation::STEP
            reservation.till = other.till
            expect(reservation).not_to be_valid
          end

          it 'overlap later' do
            reservation.from = other.from + Reservation::STEP
            reservation.till = other.till + Reservation::STEP
            expect(reservation).not_to be_valid
          end
        end
      end
    end
  end
end
