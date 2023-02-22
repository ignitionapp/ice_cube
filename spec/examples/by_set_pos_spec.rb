require File.dirname(__FILE__) + "/../spec_helper"

module IceCube
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
      let(:schedule_start) { Time.new(2023, 02, 22, 12, 0, 0) }
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
      let(:schedule_start) { Time.new(2023, 02, 22, 12, 0, 0) }
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

  describe YearlyRule, "BYSETPOS" do
    subject(:schedule) { IceCube::Schedule.from_ical(from_ical) }
    let(:from_ical) { "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1" }
    before(:each) do
      schedule.start_time = schedule_start_time
    end
    let(:occurrences) { schedule.occurrences_between(from_time, to_time) }
    let(:schedule_start_time) { Time.new(1966, 7, 5) }
    let(:from_time) { Time.new(2015, 1, 1) }
    let(:to_time) { Time.new(2017, 1, 1) }
    it "returns only the last day of each July in 2015 and 2016" do
      expect(occurrences).to eq([Time.new(2015, 7, 31), Time.new(2016, 7, 31)])
    end
  end
end
