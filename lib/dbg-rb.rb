# frozen_string_literal: true

require "json"

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

    def dbg(value)
      loc = caller_locations.first(3).last
      source_file = if (path = loc.absolute_path)
          path.split("/").last(2).join("/")
        else
          loc.label
        end

      file = if (path = loc.absolute_path)
          path
        else
          nil
        end

      input = nil

      if file
        File.open(file) do |f|
          f.each_line.with_index do |line, i|
            if i == loc.lineno - 1
              splitby, remove_parantheses = if line.include?("dbg(")
                  ["dbg(", true]
                else
                  ["dbg ", false]
                end
              input = line.split(splitby).last.chomp.strip
              input = input.sub(/\)[^)]*\z/, "") if remove_parantheses
              input
            end
          end
        end
      else
        input = nil
      end

      line = loc.lineno
      src = "[#{source_file}:#{line}]"
      value = format_val(value)

      val = if input.to_s == value.to_s || input.nil?
          "#{value}"
        else
          "#{input} = #{value}"
        end
      output = "#{src} #{val}"

      if @@highlight
        output = "#{@@highlight}\n#{output}\n#{@@highlight}"
      end

      if @@color_code != nil
        output = colorize(output, @@color_code)
      end

      puts output
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
      end.then do |value|
        if value.is_a?(String)
          value.gsub("\"nil\"", "nil").gsub("\\", "")
        else
          value
        end
      end
    end

    def dbg_inspect(obj, quote_str:)
      if quote_str && obj.is_a?(String)
        return obj.inspect
      end

      case obj
      when Numeric
        obj
      when String
        # Handle binary strings by showing their hex representation
        if obj.encoding == Encoding::ASCII_8BIT
          obj.bytes.map { |b| "\\x#{b.to_s(16).rjust(2, '0')}" }.join
        else
          obj
        end
      else
        obj.inspect
      end
    end
  end
end

def dbg(value)
  DbgRb.dbg(value)
end

DbgRb.color_code = 33 # yellow
