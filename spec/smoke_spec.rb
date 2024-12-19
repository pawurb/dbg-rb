# frozen_string_literal: true

require "spec_helper"
require "dbg-rb"
require "ostruct"

describe DbgRb do
  before do
    DbgRb.color_code = nil
  end

  it "variable values" do
    expect { dbg("123") }.to output("[spec/smoke_spec.rb:13] \"123\"\n").to_stdout
  end

  it "binded variables" do
    b = 123
    expect { dbg(:b) }.to output("[spec/smoke_spec.rb:18] b = 123\n").to_stdout
  end

  it "missing binded variables" do
    b = 123
    expect { dbg(:c) }.to output("[spec/smoke_spec.rb:23] :c\n").to_stdout
  end

  it "complex objects" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(s) }.to output("[spec/smoke_spec.rb:28] #<OpenStruct a=1, b=2>\n").to_stdout
  end

  it "binded complex objects" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(:s) }.to output("[spec/smoke_spec.rb:33] s = #<OpenStruct a=1, b=2>\n").to_stdout
  end

  it "multiple msg" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(:s, "other msg") }.to output("[spec/smoke_spec.rb:38] s = #<OpenStruct a=1, b=2>\n[spec/smoke_spec.rb:38] \"other msg\"\n").to_stdout
  end

  it "nil" do
    expect { dbg!(nil) }.to output("[spec/smoke_spec.rb:42] nil\n").to_stdout
  end

  it "higlight" do
    DbgRb.highlight!
    expect { dbg!("123") }.to output("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/smoke_spec.rb:47] \"123\"\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n").to_stdout
  end

  it "color_code" do
    DbgRb.color_code = 31
    expect { dbg!(123) }.to output("\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/smoke_spec.rb:52] 123\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m\n").to_stdout
  end

  it "alias" do
    DbgRb.highlight!(false)
    DbgRb.color_code = nil

    expect {
      dbg(123)
    }.to output("[spec/smoke_spec.rb:60] 123\n").to_stdout
  end

  it "binded nil variables" do
    b = nil
    expect { dbg(:b) }.to output("[spec/smoke_spec.rb:66] b = nil\n").to_stdout
  end
end
