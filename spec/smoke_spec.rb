# frozen_string_literal: true

require "spec_helper"
require "dbg-rb"
require "ostruct"

describe DbgRb do
  it "variable values" do
    expect { dbg("123") }.to output("[spec/smoke_spec.rb:9] \"123\"\n").to_stdout
  end

  it "binded variables" do
    b = 123
    expect { dbg(:b) }.to output("[spec/smoke_spec.rb:14] b = 123\n").to_stdout
  end

  it "missing binded variables" do
    b = 123
    expect { dbg(:c) }.to output("[spec/smoke_spec.rb:19] :c\n").to_stdout
  end

  it "complex objects" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(s) }.to output("[spec/smoke_spec.rb:24] #<OpenStruct a=1, b=2>\n").to_stdout
  end

  it "binded complex objects" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(:s) }.to output("[spec/smoke_spec.rb:29] s = #<OpenStruct a=1, b=2>\n").to_stdout
  end

  it "multiple msg" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(:s, "other msg") }.to output("[spec/smoke_spec.rb:34] s = #<OpenStruct a=1, b=2>\n[spec/smoke_spec.rb:34] \"other msg\"\n").to_stdout
  end

  it "nil" do
    expect { dbg!(nil) }.to output("[spec/smoke_spec.rb:38] nil\n").to_stdout
  end

  it "higlight" do
    DbgRb.highlight!
    expect { dbg!("123") }.to output("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/smoke_spec.rb:43] \"123\"\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n").to_stdout
  end

  it "color_code" do
    DbgRb.color_code = 31
    expect { dbg!(123) }.to output("\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/smoke_spec.rb:48] 123\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m\n").to_stdout
  end

  it "alias" do
    DbgRb.highlight!(false)
    DbgRb.color_code = nil

    expect {
      dbg(123)
    }.to output("[spec/smoke_spec.rb:56] 123\n").to_stdout
  end
end
