# frozen_string_literal: true

require "spec_helper"
require "dbg-rb"
require "ostruct"

describe DbgRb do
  before do
    DbgRb.color_code = nil
    DbgRb.highlight!(false)
  end

  it "constant values" do
    expect do
      dbg("123")
    end.to output("[spec/main_spec.rb:15] \"123\"\n").to_stdout

    expect do
      dbg(123)
    end.to output("[spec/main_spec.rb:19] 123\n").to_stdout

    expect do
      dbg(nil)
    end.to output("[spec/main_spec.rb:23] nil\n").to_stdout

    expect do
      dbg "123"
    end.to output("[spec/main_spec.rb:27] \"123\"\n").to_stdout

    expect do
      dbg 123
    end.to output("[spec/main_spec.rb:31] 123\n").to_stdout

    expect do
      dbg nil
    end.to output("[spec/main_spec.rb:35] nil\n").to_stdout
  end

  it "variables" do
    a = 123

    expect do
      dbg(a)
    end.to output("[spec/main_spec.rb:43] a = 123\n").to_stdout

    b = "123"

    expect do
      dbg(b)
    end.to output("[spec/main_spec.rb:49] b = \"123\"\n").to_stdout

    c = nil

    expect do
      dbg(c)
    end.to output("[spec/main_spec.rb:55] c = nil\n").to_stdout
  end

  it "complex objects" do
    s = OpenStruct.new(a: 1, b: 2)

    expect do
      dbg(s)
    end.to output("[spec/main_spec.rb:63] s = #<OpenStruct a=1, b=2>\n").to_stdout
  end

  it "hashes" do
    h = { a: 1, b: "2" }
    expect do
      dbg(h)
    end.to output("[spec/main_spec.rb:70] h = {\n  \"a\": 1,\n  \"b\": \"2\"\n}\n").to_stdout
  end

  it "arrays" do
    a = [1, "str"]
    expect do
      dbg(a)
    end.to output("[spec/main_spec.rb:77] a = [\n  1,\n  \"str\"\n]\n").to_stdout
  end

  it "hash formatting" do
    h = { a: 1, b: "2", c: nil }
    expect do
      dbg(h)
    end.to output("[spec/main_spec.rb:84] h = {\n  \"a\": 1,\n  \"b\": \"2\",\n  \"c\": nil\n}\n").to_stdout
  end

  it "highlight" do
    DbgRb.highlight!
    expect do
      dbg("123")
    end.to output("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/main_spec.rb:91] \"123\"\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n").to_stdout
  end

  it "color_code" do
    DbgRb.color_code = 31
    expect do
      dbg(123)
    end.to output("\e[31m[spec/main_spec.rb:98] 123\e[0m\n").to_stdout
  end

  it "highlight and color_code" do
    DbgRb.highlight!
    DbgRb.color_code = 31
    expect do
      dbg(123)
    end.to output("\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n[spec/main_spec.rb:106] 123\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m\n").to_stdout
  end

  it "complex expression" do
    expect do
      dbg([1, 2, 3].reduce(0) { |i, agg| agg + i })
    end.to output("[spec/main_spec.rb:112] [1, 2, 3].reduce(0) { |i, agg| agg + i } = 6\n").to_stdout

    expect do
      dbg [1, 2, 3].reduce(0) { |i, agg| agg + i }
    end.to output("[spec/main_spec.rb:116] [1, 2, 3].reduce(0) { |i, agg| agg + i } = 6\n").to_stdout
  end

  it "binary input" do
    random_bytes = Random.new.bytes(8)

    expect do
      dbg(random_bytes)
    end.not_to raise_error
  end
end
