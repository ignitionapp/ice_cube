require File.dirname(__FILE__) + "/../spec_helper"

module IceCube
  describe WeeklyRule, "BYSETPOS" do
    it "should behave correctly" do
      # Weekly on Monday, Wednesday, and Friday with the week starting on Wednesday, the last day of the set
      schedule = IceCube::Schedule.from_ical("RRULE:FREQ=WEEKLY;COUNT=4;WKST=WE;BYDAY=MO,WE,FR;BYSETPOS=-1")
      schedule.start_time = Time.new(2022, 12, 27, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2022, 1, 1), Time.new(2024, 1, 1)))
        .to eq([
          Time.new(2023, 1, 2, 12, 0, 0),
          Time.new(2023, 1, 9, 12, 0, 0),
          Time.new(2023, 1, 16, 12, 0, 0),
          Time.new(2023, 1, 23, 12, 0, 0)
        ])
    end

    it "should work with intervals" do
      # Every 2 weeks on Monday, Wednesday, and Friday with the week starting on Wednesday, the last day of the set
      schedule = IceCube::Schedule.from_ical("RRULE:FREQ=WEEKLY;COUNT=4;INTERVAL=2;WKST=WE;BYDAY=MO,WE,FR;BYSETPOS=-1")
      schedule.start_time = Time.new(2022, 12, 27, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2022, 1, 1), Time.new(2024, 1, 1)))
        .to eq([
          Time.new(2023, 1, 9, 12, 0, 0),
          Time.new(2023, 1, 23, 12, 0, 0),
          Time.new(2023, 2, 6, 12, 0, 0),
          Time.new(2023, 2, 20, 12, 0, 0)
        ])
    end
  end

  describe MonthlyRule, "BYSETPOS" do
    it "should behave correctly" do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=4"
      schedule.start_time = Time.new(2015, 5, 28, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2015, 1, 1), Time.new(2017, 1, 1)))
        .to eq([
          Time.new(2015, 6, 24, 12, 0, 0),
          Time.new(2015, 7, 22, 12, 0, 0),
          Time.new(2015, 8, 26, 12, 0, 0),
          Time.new(2015, 9, 23, 12, 0, 0)
        ])
    end

    it "should work with intervals" do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=4;INTERVAL=2"
      schedule.start_time = Time.new(2015, 5, 28, 12, 0, 0)
      expect(schedule.occurrences_between(Time.new(2015, 1, 1), Time.new(2017, 1, 1)))
        .to eq([
          Time.new(2015, 7, 22, 12, 0, 0),
          Time.new(2015, 9, 23, 12, 0, 0),
          Time.new(2015, 11, 25, 12, 0, 0),
          Time.new(2016, 1, 27, 12, 0, 0)
        ])
    end

    context "when billing occurs at the end of the month" do
      it "should return the correct end of the months dates" do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=-1"
        schedule.start_time = Time.new(2022, 11, 1, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2022, 10, 1), Time.new(2023, 10, 31))).to eq([
          Time.new(2022, 11, 30, 12, 0, 0),
          Time.new(2022, 12, 31, 12, 0, 0),
          Time.new(2023, 1, 31, 12, 0, 0),
          Time.new(2023, 2, 28, 12, 0, 0)
        ])
      end
    end

    context "when the rule is the first 4 Wednesdays ..." do
      it "returns the first 4 Wednesdays ..." do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=4"
        schedule.start_time = Time.new(2015, 5, 28, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2015, 1, 1), Time.new(2017, 1, 1))).to eq([
          Time.new(2015, 6, 24, 12, 0, 0),
          Time.new(2015, 7, 22, 12, 0, 0),
          Time.new(2015, 8, 26, 12, 0, 0),
          Time.new(2015, 9, 23, 12, 0, 0)
        ])
      end
    end

    context "when event occurs on a leap year" do
      it "returns the correct end of the months date including the leap month" do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=-1"
        schedule.start_time = Time.new(2019, 11, 1, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2019, 10, 1), Time.new(2020, 10, 31))).to eq([
          Time.new(2019, 11, 30, 12, 0, 0),
          Time.new(2019, 12, 31, 12, 0, 0),
          Time.new(2020, 1, 31, 12, 0, 0),
          Time.new(2020, 2, 29, 12, 0, 0)
        ])
      end
    end

    context "when the rule is the first 4 last days of the month by set pos" do
      it "returns the first 4 last days of the month by set pos" do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=-1"
        schedule.start_time = Time.new(2022, 11, 1, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2022, 10, 1), Time.new(2023, 10, 31))).to eq([
          Time.new(2022, 11, 30, 12, 0, 0),
          Time.new(2022, 12, 31, 12, 0, 0),
          Time.new(2023, 1, 31, 12, 0, 0),
          Time.new(2023, 2, 28, 12, 0, 0)
        ])
      end

      it "returns the first 4 last days of the month by set pos" do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30;BYSETPOS=-1"
        schedule.start_time = Time.new(2019, 11, 30, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2019, 11, 1), Time.new(2020, 6, 30))).to eq([
          Time.new(2019, 11, 30, 12, 0, 0),
          Time.new(2019, 12, 30, 12, 0, 0),
          Time.new(2020, 1, 30, 12, 0, 0),
          Time.new(2020, 2, 29, 12, 0, 0)
        ])
      end
    end

    context "when the rule is for the first 4 second last days of the month by set pos" do
      it "returns the first 4 previous last days of the month by set pos" do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=27,28,29,30,31;BYSETPOS=-2"
        schedule.start_time = Time.new(2022, 11, 1, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2022, 10, 1), Time.new(2023, 10, 31))).to eq([
          Time.new(2022, 11, 29, 12, 0, 0),
          Time.new(2022, 12, 30, 12, 0, 0),
          Time.new(2023, 1, 30, 12, 0, 0),
          Time.new(2023, 2, 27, 12, 0, 0)
        ])
      end
    end

    context "when the rule is the first 4 after the last days of the month by set pos" do
      it "returns the first 4 previous last days of the month by set pos" do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYMONTHDAY=28,29,30,31;BYSETPOS=4"
        schedule.start_time = Time.new(2023, 2, 22, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2022, 10, 1), Time.new(2023, 10, 31))).to eq([
          Time.new(2023, 3, 31, 12, 0, 0),
          Time.new(2023, 5, 31, 12, 0, 0),
          Time.new(2023, 7, 31, 12, 0, 0),
          Time.new(2023, 8, 31, 12, 0, 0)
        ])
      end
    end

    context "when the rule is the first 4 after the last wednesday of the month" do
      it "returns the first 4 previous last days of the month by set pos" do
        schedule = IceCube::Schedule.from_ical "RRULE:FREQ=MONTHLY;COUNT=4;BYDAY=WE;BYSETPOS=-1"
        schedule.start_time = Time.new(2023, 2, 22, 12, 0, 0)
        expect(schedule.occurrences_between(Time.new(2022, 10, 1), Time.new(2023, 10, 31))).to eq([
          Time.new(2023, 2, 22, 12, 0, 0),
          Time.new(2023, 3, 29, 12, 0, 0),
          Time.new(2023, 4, 26, 12, 0, 0),
          Time.new(2023, 5, 31, 12, 0, 0)
        ])
      end
    end
  end

  describe YearlyRule, "BYSETPOS" do
    it "should behave correctly" do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1"
      schedule.start_time = Time.new(1966, 7, 5)
      expect(schedule.occurrences_between(Time.new(2015, 1, 1), Time.new(2017, 1, 1)))
        .to eq([
          Time.new(2015, 7, 31),
          Time.new(2016, 7, 31)
        ])
    end

    it "should work with intervals" do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1;INTERVAL=2"
      schedule.start_time = Time.new(1966, 7, 5)
      expect(schedule.occurrences_between(Time.new(2015, 1, 1), Time.new(2023, 1, 1)))
        .to eq([
          Time.new(2016, 7, 31),
          Time.new(2018, 7, 31),
          Time.new(2020, 7, 31),
          Time.new(2022, 7, 31)
        ])
    end

    it "should work with counts" do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1;COUNT=3"
      schedule.start_time = Time.new(2016, 1, 1)
      expect(schedule.occurrences_between(Time.new(2016, 1, 1), Time.new(2050, 1, 1)))
        .to eq([
          Time.new(2016, 7, 31),
          Time.new(2017, 7, 31),
          Time.new(2018, 7, 31)
        ])
    end

    it "should work with counts and intervals" do
      schedule = IceCube::Schedule.from_ical "RRULE:FREQ=YEARLY;BYMONTH=7;BYDAY=SU,MO,TU,WE,TH,FR,SA;BYSETPOS=-1;COUNT=3;INTERVAL=2"
      schedule.start_time = Time.new(2016, 1, 1)
      expect(schedule.occurrences_between(Time.new(2016, 1, 1), Time.new(2050, 1, 1)))
        .to eq([
          Time.new(2016, 7, 31),
          Time.new(2018, 7, 31),
          Time.new(2020, 7, 31)
        ])
    end
  end
end
