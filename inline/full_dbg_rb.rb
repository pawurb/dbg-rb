# frozen_string_literal: true

require "json"
require_relative "debug_inspector"

# Source https://github.com/banister/binding_of_caller
# The MIT License

# Copyright (c) 2011 John Mair (banisterfiend)

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module BindingOfCaller
  module BindingExtensions
    # Retrieve the binding of the nth caller of the current frame.
    # @return [Binding]
    def of_caller(n)
      c = callers.drop(1)
      if n > (c.size - 1)
        raise "No such frame, gone beyond end of stack!"
      else
        c[n]
      end
    end

    # Return bindings for all caller frames.
    # @return [Array<Binding>]
    def callers
      ary = []

      DebugInspector.open do |dc|
        locs = dc.backtrace_locations

        locs.size.times do |i|
          b = dc.frame_binding(i)
          if b
            b.instance_variable_set(:@iseq, dc.frame_iseq(i))
            ary << b
          end
        end
      end

      ary.drop(1)
    end

    # Number of parent frames available at the point of call.
    # @return [Fixnum]
    def frame_count
      callers.size - 1
    end

    # The type of the frame.
    # @return [Symbol]
    def frame_type
      return nil if !@iseq

      # apparently the 9th element of the iseq array holds the frame type
      # ...not sure how reliable this is.
      @frame_type ||= @iseq.to_a[9]
    end

    # The description of the frame.
    # @return [String]
    def frame_description
      return nil if !@iseq
      @frame_description ||= @iseq.label
    end
  end
end

class ::Binding
  include BindingOfCaller::BindingExtensions
end

# Source https://github.com/pawurb/dbg-rb
# The MIT License (MIT)

# Copyright © Paweł Urbanek 2024

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
module DbgRb
  def self.color_code=(val)
    Impl.color_code = val
  end

  def self.highlight!(wrapper = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    Impl.highlight!(wrapper)
  end

  def self.dbg(*msgs)
    Impl.new.dbg(*msgs)
  end

  class Impl
    @@color_code = nil
    @@highlight = false

    def self.color_code=(val)
      @@color_code = val
    end

    def self.highlight!(wrapper)
      @@highlight = wrapper
    end

    def dbg(*msgs)
      loc = caller_locations.first(3).last
      file = if (path = loc.absolute_path)
          path.split("/").last(2).join("/")
        else
          loc.label
        end

      line = loc.lineno
      src = "[#{file}:#{line}]"

      msgs.each_with_index do |obj, i|
        first = i == 0
        last = i == (msgs.size - 1)

        val = if obj.is_a?(Symbol)
            begin
              val = binding.of_caller(4).local_variable_get(obj)
              val = format_val(val)

              "#{obj} = #{val}"
            rescue NameError
              obj.inspect
            end
          else
            format_val(obj)
          end

        output = "#{src} #{val}"

        if @@highlight
          if first
            output = "#{@@highlight}\n#{output}"
          end

          if last
            output = "#{output}\n#{@@highlight}"
          end
        end

        if @@color_code != nil
          output = colorize(output, @@color_code)
        end

        puts output
      end

      nil
    end

    private

    def colorize(str, color_code)
      "\e[#{color_code}m#{str}\e[0m"
    end

    def format_val(val)
      if val.is_a?(Hash)
        res = val.map { |k, v| [k, dbg_inspect(v, quote_str: false)] }.to_h
        JSON.pretty_generate(res)
      elsif val.is_a?(Array)
        JSON.pretty_generate(val.map do |v|
          dbg_inspect(v, quote_str: false)
        end)
      else
        dbg_inspect(val, quote_str: true)
      end
    end

    def dbg_inspect(obj, quote_str:)
      if quote_str && obj.is_a?(String)
        return obj.inspect
      end

      case obj
      when Numeric, String
        obj
      else
        obj.inspect
      end
    end
  end
end

def dbg(*msgs)
  DbgRb.dbg(*msgs)
end

DbgRb.color_code = 33 # yellow
