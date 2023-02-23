require File.dirname(__FILE__) + "/../spec_helper"

module IceCube
  describe WeeklyRule, 'BYSETPOS' do
    it 'should behave correctly' do
      # Weekly on Monday, Wednesday, and Friday with the week starting on Wednesday, the last day of the set
      schedule = IceCube::Schedule.from_ical("RRULE:FREQ=WEEKLY;COUNT=4;WKST=WE;BYDAY=MO,WE,FR;BYSETPOS=-1")
      schedule.start_time = Time.new(2022, 12, 27, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2022, 01, 01), Time.new(2024, 01, 01))).
        to eq([
                Time.new(2023,1,2,12,0,0),
                Time.new(2023,1,9,12,0,0),
                Time.new(2023,1,16,12,0,0),
                Time.new(2023,1,23,12,0,0)
              ])
    end

    it 'should work with intervals' do
      # Every 2 weeks on Monday, Wednesday, and Friday with the week starting on Wednesday, the last day of the set
      schedule = IceCube::Schedule.from_ical("RRULE:FREQ=WEEKLY;COUNT=4;INTERVAL=2;WKST=WE;BYDAY=MO,WE,FR;BYSETPOS=-1")
      schedule.start_time = Time.new(2022, 12, 27, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2022, 01, 01), Time.new(2024, 01, 01))).
        to eq([
                Time.new(2023,1,9,12,0,0),
                Time.new(2023,1,23,12,0,0),
                Time.new(2023,2,6,12,0,0),
                Time.new(2023,2,20,12,0,0)
              ])
    end
  end

  describe MonthlyRule, 'BYSETPOS' do
    it 'should behave correctly' do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=4"
      schedule.start_time = Time.new(2015, 5, 28, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2015, 01, 01), Time.new(2017, 01, 01))).
        to eq([
                Time.new(2015,6,24,12,0,0),
                Time.new(2015,7,22,12,0,0),
                Time.new(2015,8,26,12,0,0),
                Time.new(2015,9,23,12,0,0)
              ])
    end

    it 'should work with intervals' do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=4;INTERVAL=2"
      schedule.start_time = Time.new(2015, 5, 28, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2015, 01, 01), Time.new(2017, 01, 01))).
        to eq([
                Time.new(2015,7,22,12,0,0),
                Time.new(2015,9,23,12,0,0),
                Time.new(2015,11,25,12,0,0),
                Time.new(2016,1,27,12,0,0),
              ])
    end

    context 'when billing occurs at the end of the month' do
      it 'should return the correct end of the months dates' do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=-1"
        schedule.start_time = Time.new(2022, 11, 1, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2022, 10, 01), Time.new(2023, 10, 31))).to eq([
           Time.new(2022,11,30,12,0,0),
           Time.new(2022,12,31,12,0,0),
           Time.new(2023,01,31,12,0,0),
           Time.new(2023,02,28,12,0,0)
         ])
      end
    end
  end

  describe MonthlyRule, "BYSETPOS" do
    subject(:schedule) { IceCube::Schedule.from_ical(from_ical) }
    before(:each) do
      schedule.start_time = schedule_start
    end
    let(:occurrences) { schedule.occurrences_between(from_time, to_time) }
    context "when the rule is the first 4 Wednesdays ..." do
      let(:from_ical) { "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=4" }
      let(:schedule_start) { Time.new(2015, 5, 28, 12, 0, 0) }
      let(:from_time) { Time.new(2015, 1, 1) }
      let(:to_time) { Time.new(2017, 1, 1) }
      it "returns the first 4 Wednesdays ..." do
        expect(occurrences).to eq(
                                 [
                                   Time.new(2015, 6, 24, 12, 0, 0),
                                   Time.new(2015, 7, 22, 12, 0, 0),
                                   Time.new(2015, 8, 26, 12, 0, 0),
                                   Time.new(2015, 9, 23, 12, 0, 0)
                                 ]
                               )
      end
    end

    context "when event occurs on a leap year" do
      let(:from_ical) { "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=-1" }
      let(:schedule_start) { Time.new(2019, 11, 1, 12, 0, 0) }
      let(:from_time) { Time.new(2019, 10, 1) }
      let(:to_time) { Time.new(2020, 10, 31) }
      it "returns the correct end of the months date including the leap month" do
        expect(occurrences).to eq(
                                 [
                                   Time.new(2019, 11, 30, 12, 0, 0),
                                   Time.new(2019, 12, 31, 12, 0, 0),
                                   Time.new(2020, 1, 31, 12, 0, 0),
                                   Time.new(2020, 2, 29, 12, 0, 0)
                                 ]
                               )
      end
    end

    context "when the rule is the first 4 last days of the month by set pos" do
      let(:from_ical) { "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=-1" }
      let(:schedule_start) { Time.new(2022, 11, 1, 12, 0, 0) }
      let(:from_time) { Time.new(2022, 10, 1) }
      let(:to_time) { Time.new(2023, 10, 31) }
      it "returns the first 4 last days of the month by set pos" do
        expect(occurrences).to eq(
                                 [
                                   Time.new(2022, 11, 30, 12, 0, 0),
                                   Time.new(2022, 12, 31, 12, 0, 0),
                                   Time.new(2023, 1, 31, 12, 0, 0),
                                   Time.new(2023, 2, 28, 12, 0, 0)
                                 ]
                               )
      end
    end

    context "when the rule is for the first 4 second last days of the month by set pos" do
      let(:from_ical) { "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=27,28,29,30,31;BYSETPOS=-2" }
      let(:schedule_start) { Time.new(2022, 11, 1, 12, 0, 0) }
      let(:from_time) { Time.new(2022, 10, 1) }
      let(:to_time) { Time.new(2023, 10, 31) }
      it "returns the first 4 previous last days of the month by set pos" do
        expect(occurrences).to eq(
                                 [
                                   Time.new(2022, 11, 29, 12, 0, 0),
                                   Time.new(2022, 12, 30, 12, 0, 0),
                                   Time.new(2023, 1, 30, 12, 0, 0),
                                   Time.new(2023, 2, 27, 12, 0, 0)
                                 ]
                               )
      end
    end

    context "when the rule is the first 4 after the last days of the month by set pos" do
      let(:from_ical) { "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=4" }
      let(:schedule_start) { Time.new(2023, 2, 22, 12, 0, 0) }
      let(:from_time) { Time.new(2022, 10, 1) }
      let(:to_time) { Time.new(2023, 10, 31) }
      it "returns the first 4 previous last days of the month by set pos" do
        expect(occurrences).to eq(
                                 [
                                   Time.new(2023, 3, 31, 12, 0, 0),
                                   Time.new(2023, 5, 31, 12, 0, 0),
                                   Time.new(2023, 7, 31, 12, 0, 0),
                                   Time.new(2023, 8, 31, 12, 0, 0)
                                 ]
                               )
      end
    end

    context "when the rule is the first 4 after the last wednesday of the month" do
      let(:from_ical) { "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=-1" }
      let(:schedule_start) { Time.new(2023, 2, 22, 12, 0, 0) }
      let(:from_time) { Time.new(2022, 10, 1) }
      let(:to_time) { Time.new(2023, 10, 31) }
      it "returns the first 4 previous last days of the month by set pos" do
        expect(occurrences).to eq(
                                 [
                                   Time.new(2023, 2, 22, 12, 0, 0),
                                   Time.new(2023, 3, 29, 12, 0, 0),
                                   Time.new(2023, 4, 26, 12, 0, 0),
                                   Time.new(2023, 5, 31, 12, 0, 0)
                                 ]
                               )
      end
    end
  end

  describe MonthlyRule, "BYSETPOS and BYDAY" do
    context "when the rules include more varied set of BYDAY values" do
      let(:start_date) { Date.new(2023, 1, 1) }

      it "generates the expected dates" do
        rrules = [
          "RRULE:FREQ=MONTHLY;BYDAY=1FR,3FR;BYSETPOS=1,3",
          "RRULE:FREQ=MONTHLY;BYDAY=1MO,-1MO;BYSETPOS=1,-1",
          "RRULE:FREQ=MONTHLY;BYDAY=2WE,4WE;BYSETPOS=2,4",
          "RRULE:FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-1",
          "RRULE:FREQ=MONTHLY;BYDAY=2FR;BYMONTHDAY=16,17,18,19,20,21,22;BYSETPOS=2"
        ]

        expected_dates = [
          Date.new(2023, 3, 3), Date.new(2023, 2, 27),
          Date.new(2023, 3, 22), Date.new(2023, 2, 28),
          nil
        ]

        rrules.each_with_index do |rrule, i|
          schedule = IceCube::Schedule.from_ical(rrule)
          dates = schedule.occurrences_between(start_date, start_date + 6.months)
          expect(dates.map(&:to_date).first).to eq(expected_dates[i])
        end
      end
    end
  end


  describe YearlyRule, 'BYSETPOS' do
    it 'should behave correctly' do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1"
      schedule.start_time = Time.new(1966,7,5)
      expect(schedule.occurrences_between(Time.new(2015, 01, 01), Time.new(2017, 01, 01))).
        to eq([
                Time.new(2015, 7, 31),
                Time.new(2016, 7, 31)
              ])
    end

    it 'should work with intervals' do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1;INTERVAL=2"
      schedule.start_time = Time.new(1966,7,5)
      expect(schedule.occurrences_between(Time.new(2015, 01, 01), Time.new(2023, 01, 01))).
        to eq([
          Time.new(2016, 7, 31),
          Time.new(2018, 7, 31),
          Time.new(2020, 7, 31),
          Time.new(2022, 7, 31),
        ])
    end

    it 'should work with counts' do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1;COUNT=3"
      schedule.start_time = Time.new(2016,1,1)
      expect(schedule.occurrences_between(Time.new(2016, 01, 01), Time.new(2050, 01, 01))).
        to eq([
          Time.new(2016, 7, 31),
          Time.new(2017, 7, 31),
          Time.new(2018, 7, 31),
        ])
    end

    it 'should work with counts and intervals' do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1;COUNT=3;INTERVAL=2"
      schedule.start_time = Time.new(2016,1,1)
      expect(schedule.occurrences_between(Time.new(2016, 01, 01), Time.new(2050, 01, 01))).
        to eq([
          Time.new(2016, 7, 31),
          Time.new(2018, 7, 31),
          Time.new(2020, 7, 31),
        ])
    end
  end
end
