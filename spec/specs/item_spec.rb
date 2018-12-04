require 'spec_helper'
require 'action_nav/base'

describe ActionNav::Item do

  it "should be able to add children" do
    item1 = ActionNav::Item.new(nil, :level1)
    item2 = item1.add_child(:level2)
    item3 = item2.add_child(:level3)
    expect(item1.children[:level2]).to eq item2
    expect(item2.children[:level3]).to eq item3
  end

  context "#child" do

    it "should be able to find child items" do
      item1 = ActionNav::Item.new(nil, :level1)
      item2 = item1.add_child(:level2)
      item3 = item2.add_child(:level3)

      expect(item1.child(:level2)).to eq item2
      expect(item1.child(:level2, :level3)).to eq item3
    end

    it "should return nil if no child can be found" do
      item1 = ActionNav::Item.new(nil, :level1)
      item2 = item1.add_child(:level2)
      expect(item1.child(:blah)).to eq nil
      expect(item1.child(:blah, :blah)).to eq nil
      expect(item1.child(:level2, :blah)).to eq nil
    end
  end

end
