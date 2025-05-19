# frozen_string_literal: true

require "spec_helper"
require "ostruct"
require_relative "../inline/dbg_rb"

describe DbgRb do
  before do
    DbgRb.color_code = nil
  end

  it "constant values" do
    expect do
      dbg("123")
    end.to output("[spec/inline_spec.rb:14] \"123\"\n").to_stdout

    expect do
      dbg(123)
    end.to output("[spec/inline_spec.rb:18] 123\n").to_stdout

    expect do
      dbg(nil)
    end.to output("[spec/inline_spec.rb:22] nil\n").to_stdout

    expect do
      dbg "123"
    end.to output("[spec/inline_spec.rb:26] \"123\"\n").to_stdout

    expect do
      dbg 123
    end.to output("[spec/inline_spec.rb:30] 123\n").to_stdout

    expect do
      dbg nil
    end.to output("[spec/inline_spec.rb:34] nil\n").to_stdout
  end

  it "variables" do
    a = 123

    expect do
      dbg(a)
    end.to output("[spec/inline_spec.rb:42] a = 123\n").to_stdout

    b = "123"

    expect do
      dbg(b)
    end.to output("[spec/inline_spec.rb:48] b = \"123\"\n").to_stdout

    c = nil

    expect do
      dbg(c)
    end.to output("[spec/inline_spec.rb:54] c = nil\n").to_stdout
  end

  it "complex objects" do
    s = OpenStruct.new(a: 1, b: 2)

    expect do
      dbg(s)
    end.to output("[spec/inline_spec.rb:62] s = #<OpenStruct a=1, b=2>\n").to_stdout
  end

  it "hashes" do
    h = { a: 1, b: "2" }
    expect do
      dbg(h)
    end.to output("[spec/inline_spec.rb:69] h = {\n  \"a\": 1,\n  \"b\": \"2\"\n}\n").to_stdout
  end

  it "arrays" do
    a = [1, "str"]
    expect do
      dbg(a)
    end.to output("[spec/inline_spec.rb:76] a = [\n  1,\n  \"str\"\n]\n").to_stdout
  end

  it "highlight" do
    DbgRb.highlight!
    expect do
      dbg("123")
    end.to output("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/inline_spec.rb:83] \"123\"\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n").to_stdout
  end

  it "color_code" do
    DbgRb.color_code = 31
    expect do
      dbg(123)
    end.to output("\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/inline_spec.rb:90] 123\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m\n").to_stdout
  end

  it "highlight and color_code" do
    DbgRb.highlight!
    DbgRb.color_code = 31
    expect do
      dbg(123)
    end.to output("\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/inline_spec.rb:98] 123\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m\n").to_stdout
  end
end
