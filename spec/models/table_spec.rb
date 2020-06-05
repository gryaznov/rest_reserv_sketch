# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Table, type: :model do
  describe '#reserve_for' do
    let(:user) { create :user }
    let(:restaurant) { create :restaurant }
    let(:table)  { create :table, number: 1, restaurant: restaurant }
    let(:table2) { create :table, number: 2, restaurant: restaurant }
    let(:date) { Date.new(2020, 6, 6) }

    context 'success' do
      it 'creates reservation with till' do
        expect do
          table.reserve_for(user: user, date: date, from: '12:00', till: '12:30')
        end.to change { Reservation.count }.by(1)

        reservation = Reservation.last

        expect(reservation.user).to eq user
        expect(reservation.table).to eq table
        expect(reservation.restaurant).to eq restaurant
        expect(Time.at(reservation.from).strftime('%H:%M')).to eq '12:00'
        expect(Time.at(reservation.till).strftime('%H:%M')).to eq '12:30'
      end

      it 'creates reservation without till but with steps' do
        expect do
          table.reserve_for(user: user, date: date, from: '12:00', steps: 5)
        end.to change { Reservation.count }.by(1)

        reservation = Reservation.last

        expect(reservation.user).to eq user
        expect(reservation.table).to eq table
        expect(reservation.restaurant).to eq restaurant
        expect(Time.at(reservation.from).strftime('%H:%M')).to eq '12:00'
        expect(Time.at(reservation.till).strftime('%H:%M')).to eq '14:30'
      end

      it 'creates reservation without till and steps' do
        expect do
          table.reserve_for(user: user, date: date, from: '12:00')
        end.to change { Reservation.count }.by(1)

        reservation = Reservation.last

        expect(reservation.user).to eq user
        expect(reservation.table).to eq table
        expect(reservation.restaurant).to eq restaurant
        expect(Time.at(reservation.from).strftime('%H:%M')).to eq '12:00'
        expect(Time.at(reservation.till).strftime('%H:%M')).to eq '12:30'
      end
    end

    context 'failure' do
      context 'restaurant' do
        it 'does not create a reservation if from is out of schedule' do
          expect { table.reserve_for(user: user, date: date, from: '07:00', till: '12:30') }.to \
            raise_error(ActiveRecord::RecordInvalid, 'Validation failed: should match restaurant schedule')
        end

        it 'does not create a reservation if till is out of schedule' do
          expect { table.reserve_for(user: user, date: date, from: '12:00', till: '05:00') }.to \
            raise_error(ActiveRecord::RecordInvalid, 'Validation failed: should match restaurant schedule')
        end
      end

      context 'table' do
        # 1591435800 is 2020-06-06 12:30:00
        # 1591439400 is 2020-06-06 13:30:00
        let!(:reservation) { create :reservation, table: table, date: date, from: 1591435800, till: 1591439400 }

        it 'does not create a reservation with overlapping 1:1' do
          expect { table.reserve_for(user: user, date: date, from: '12:30', till: '13:30') }.to \
            raise_error(ActiveRecord::RecordInvalid, 'Validation failed: already reserved')
        end

        it 'does not create a reservation with overlapping till' do
          expect { table.reserve_for(user: user, date: date, from: '12:00', till: '13:00') }.to \
            raise_error(ActiveRecord::RecordInvalid, 'Validation failed: already reserved')
        end

        it 'does not create a reservation with overlapping from' do
          expect { table.reserve_for(user: user, date: date, from: '13:00', till: '14:00') }.to \
            raise_error(ActiveRecord::RecordInvalid, 'Validation failed: already reserved')
        end
      end
    end
  end
end
