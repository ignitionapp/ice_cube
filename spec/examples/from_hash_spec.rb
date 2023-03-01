require File.dirname(__FILE__) + "/../spec_helper"

describe IceCube, "from_hash" do
  context "when recreating the rule from a hash" do
    it "should return a proper ical representation after being rehashed for YEARLY / BYSETPOS combo" do
      rule_from_ical = ::IceCube::Rule.from_ical "FREQ=YEARLY;COUNT=12;BYYEARDAY=31;BYSETPOS=-1"
      rule_from_hash = ::IceCube::Rule.from_hash(rule_from_ical.to_hash)
      expect(rule_from_hash.to_ical).to eq(rule_from_ical.to_ical)
    end

    it "should return a proper ical representation after being rehashed for MONTHLY / BYSETPOS combo" do
      rule_from_ical = ::IceCube::Rule.from_ical "FREQ=MONTHLY;COUNT=12;BYMONTHDAY=28,29,30;BYSETPOS=-1"
      rule_from_hash = ::IceCube::Rule.from_hash(rule_from_ical.to_hash)
      expect(rule_from_hash.to_ical).to eq(rule_from_ical.to_ical)

      rule_from_ical = ::IceCube::Rule.from_ical "FREQ=MONTHLY;COUNT=12;BYMONTHDAY=28,29,30;BYSETPOS=-1,-1"
      rule_from_hash = ::IceCube::Rule.from_hash(rule_from_ical.to_hash)
      expect(rule_from_hash.to_ical).to eq(rule_from_ical.to_ical)
    end

    it "should return a proper ical representation after being rehashed for WEEKLY / BYSETPOS combo" do
      rule_from_ical = ::IceCube::Rule.from_ical "FREQ=WEEKLY;COUNT=12;BYDAY=MO,TU;BYSETPOS=-1"
      rule_from_hash = ::IceCube::Rule.from_hash(rule_from_ical.to_hash)
      expect(rule_from_hash.to_ical).to eq(rule_from_ical.to_ical)
    end

    it "should return a proper ical representation after being rehashed for rule without BYSETPOS param" do
      rule_from_ical = ::IceCube::Rule.from_ical "FREQ=WEEKLY;COUNT=30;INTERVAL=1;WKST=MO;BYDAY=MO"
      rule_from_hash = ::IceCube::Rule.from_hash(rule_from_ical.to_hash)
      expect(rule_from_hash.to_ical).to eq(rule_from_ical.to_ical)
    end
  end
end
