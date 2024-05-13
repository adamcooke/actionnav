require 'spec_helper'
require 'action_nav/base'

describe ActionNav::ItemInstance do

  subject(:base) do
    Class.new(ActionNav::Base)
  end

  subject(:item) do
    base.item(:level1)
  end

  subject(:nav) do
    base.new(FakeController.new(:option => 1))
  end

  subject(:instance) do
    ActionNav::ItemInstance.new(nav, item)
  end

  context "#path" do
    it "should return the path" do
      expect(instance.path).to eq item.path
    end
  end

  context "#active?" do
    it "should not be active by default" do
      expect(instance.active?).to be false
    end

    it "should be able to be activated" do
      nav.activate :level1
      expect(instance.active?).to be true
    end

    it "should be active if any of its children are active?" do
      level2 = ActionNav::ItemInstance.new(nav, item.add_child(:level2))
      level2_1 = ActionNav::ItemInstance.new(nav, item.add_child(:level2_1))
      level3 = ActionNav::ItemInstance.new(nav, level2.item.add_child(:level3))
      level3_1 = ActionNav::ItemInstance.new(nav, level2.item.add_child(:level3_1))
      nav.activate :level1, :level2, :level3
      expect(level3.active?).to be true
      expect(level3_1.active?).to be false
      expect(level2.active?).to be true
      expect(level2_1.active?).to be false
      expect(instance.active?).to be true
    end
  end

  context "#items" do
    it "should return child items" do
      child = item.add_child(:level2)
      expect(instance.items.first).to be_a ActionNav::ItemInstance
      expect(instance.items.first.item).to eq child
    end
  end

  context "#url" do
    it "should return strings" do
      item.url = "/some/path"
      expect(instance.url).to eq "/some/path"
    end

    it "should call procs in the controller instance" do
      item.url = proc { "/some/path/#{opts[:option]}"}
      expect(instance.url).to eq "/some/path/1"
    end

    it "should reutrn the root if NO url is given" do
      expect(instance.url).to eq "/"
    end
  end

  context "#icon?" do
    it "should return true if there is an icon" do
      item.icon = "path/to/icon.svg"
      expect(instance.icon?).to be true
    end

    it "should return false if there is no icon" do
      expect(instance.icon?).to be false
    end
  end

  context "#icon" do
    it "should return strings" do
      item.icon = "path/to/icon.svg"
      expect(instance.icon).to eq "path/to/icon.svg"
    end

    it "should call procs in controller instance" do
      item.icon = proc { "path/to/icon/#{opts[:option]}.svg" }
      expect(instance.icon).to eq "path/to/icon/1.svg"
    end

    it "should return nil if there's no icon" do
      expect(instance.icon).to be nil
    end
  end

  context "#meta" do
    it "should return strings" do
      item.meta = { hello: 'world' }
      expect(instance.meta).to eq({ hello: 'world' })
    end

    it "should call procs in controller instance" do
      item.meta = proc { { hello: 'world' } }
      expect(instance.meta).to eq({ hello: 'world' })
    end

    it "should return an empty hash if there's no meta" do
      expect(instance.meta).to eq({})
    end
  end

  context "#title" do
    it "should return strings" do
      item.title = "Dashboard"
      expect(instance.title).to eq "Dashboard"
    end

    it "should call procs in controller instance" do
      item.title = proc { "Dashboard" }
      expect(instance.title).to eq "Dashboard"
    end

    it "should return the ID as a capitalized string if there's no title" do
      expect(instance.title).to eq "Level1"
    end
  end

  context "#description?" do
    it "should return true if there is an icon" do
      item.description = "Some description"
      expect(instance.description?).to be true
    end

    it "should return false if there is no description" do
      expect(instance.description?).to be false
    end
  end

  context "#description" do
    it "should return strings" do
      item.description = "An example description"
      expect(instance.description).to eq "An example description"
    end

    it "should call procs in controller instance" do
      item.description = proc { "An example description" }
      expect(instance.description).to eq "An example description"
    end

    it "should return nil if there's no description" do
      expect(instance.description).to be nil
    end
  end

  context "hide?" do
    it "should return true if the condition evaluates to false" do
      item.hide_unless = proc { false }
      expect(instance.hidden?).to be true
    end

    it "should return false if there's no condition" do
      expect(instance.hidden?).to be false
    end
    it "should return false if the condition returns true" do
      item.hide_unless = proc { true }
      expect(instance.hidden?).to be false
    end
  end

  context "count" do
    it "should return the count for an item" do
      item.count = proc { 1234 }
      expect(instance.count).to eq 1234
    end

    it "should only execute the block once" do
      executions = 0
      item.count = proc { executions += 1; 1234 }
      3.times { instance.count }
      expect(executions).to eq 1
    end

    it "should return nil if there's no block configured" do
      expect(instance.count).to be nil
    end
  end

end
