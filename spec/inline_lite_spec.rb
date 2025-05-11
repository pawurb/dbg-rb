# frozen_string_literal: true

require "spec_helper"
require_relative "../inline/lite_dbg_rb"
require "ostruct"

describe DbgRb do
  before do
    DbgRb.color_code = nil
  end

  it "variable values" do
    expect { dbg("123") }.to output("[spec/inline_lite_spec.rb:13] \"123\"\n").to_stdout
  end

  it "does not work with binded variables" do
    b = 123
    expect { dbg(:b) }.to output("[spec/inline_lite_spec.rb:18] :b\n").to_stdout
  end

  it "complex objects" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(s) }.to output("[spec/inline_lite_spec.rb:23] #<OpenStruct a=1, b=2>\n").to_stdout
  end

  it "multiple msg" do
    s = OpenStruct.new(a: 1, b: 2)
    expect { dbg!(:s, "other msg") }.to output("[spec/inline_lite_spec.rb:28] s = #<OpenStruct a=1, b=2>\n[spec/inline_lite_spec.rb:28] \"other msg\"\n").to_stdout
  end

  it "nil" do
    expect { dbg!(nil) }.to output("[spec/inline_lite_spec.rb:32] nil\n").to_stdout
  end

  it "highlight" do
    DbgRb.highlight!
    expect { dbg!("123") }.to output("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/inline_lite_spec.rb:37] \"123\"\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n").to_stdout
  end

  it "color_code" do
    DbgRb.color_code = 31
    expect { dbg!(123) }.to output("\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/inline_lite_spec.rb:42] 123\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m\n").to_stdout
  end

  it "alias" do
    DbgRb.highlight!(false)
    DbgRb.color_code = nil

    expect {
      dbg(123)
    }.to output("[spec/inline_lite_spec.rb:50] 123\n").to_stdout
  end

  it "hashes" do
    h = { a: 1, b: "2" }
    expect { dbg!(h) }.to output("[spec/inline_lite_spec.rb:56] {\n  \"a\": 1,\n  \"b\": \"2\"\n}\n").to_stdout
  end

  it "arrays" do
    a = [1, "str"]
    expect { dbg!(a) }.to output("[spec/inline_lite_spec.rb:61] [\n  1,\n  \"str\"\n]\n").to_stdout
  end
end
