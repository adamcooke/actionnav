require 'spec_helper'
require 'action_nav/base'

describe ActionNav::Base do

  subject(:controller) { FakeController.new }
  subject(:base) { Class.new(ActionNav::Base) }

  it "should allow items to be added" do
    expect(base.item(:name)).to be_a(ActionNav::Item)
    expect(base.items[:name]).to be_a(ActionNav::Item)
  end

  it "should return instance items" do
    base.item(:name)
    navigation = base.new(controller)
    expect(navigation.items.first).to be_a(ActionNav::ItemInstance)
    expect(navigation.items.first.id).to eq :name
    expect(navigation.items.first.path).to eq [:name]
  end

  it "should allow items to be added and use the DSL" do
    base.item(:name) do
      title "Some name"
    end
    expect(base.items[:name].title).to eq "Some name"
  end

end
