require 'spec_helper'
require 'action_nav/item_dsl'

describe ActionNav::ItemDSL do

  subject(:item) { ActionNav::Item.new(nil, :level1) }

  it "should be able to set titles" do
    item.dsl do
      title "Some title"
    end
    expect(item.title).to eq "Some title"
  end

  it "should be able to set titles to procs" do
    item.dsl do
      title { "Some title" }
    end
    expect(item.title).to be_a Proc
  end

  it "should be able to set description" do
    item.dsl do
      description "Some description"
    end
    expect(item.description).to eq "Some description"
  end

  it "should be able to set descriptions to procs" do
    item.dsl do
      description { "Some description" }
    end
    expect(item.description).to be_a Proc
  end

  it "should be able to set icons" do
    item.dsl do
      icon "Some icon"
    end
    expect(item.icon).to eq "Some icon"
  end

  it "should be able to set icons to procs" do
    item.dsl do
      icon { "Some icon" }
    end
    expect(item.icon).to be_a Proc
  end

  it "should be able to set urls" do
    item.dsl do
      url "/blah"
    end
    expect(item.url).to eq "/blah"
  end

  it "should be able to set urls to procs" do
    item.dsl do
      url { "/blah" }
    end
    expect(item.url).to be_a Proc
  end

  it "should be able to add children" do
    item.dsl do
      item :level2 do
        title "Some level 2 title"
      end
    end
    expect(item.children[:level2].title).to eq "Some level 2 title"
  end

  it "should be able to define a count block" do
    block = proc { 123 }
    item.dsl do
      item :messages do
        count(&block)
      end
    end
    expect(item.children[:messages].count).to eq block
  end

end
