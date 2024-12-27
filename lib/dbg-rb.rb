# frozen_string_literal: true

require "binding_of_caller"
require "json"

module DbgRb
  def self.color_code=(val)
    Impl.color_code = val
  end

  def self.highlight!(wrapper = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    Impl.highlight!(wrapper)
  end

  def self.dbg!(*msgs)
    Impl.new.dbg!(*msgs)
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

    def dbg!(*msgs)
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

def dbg!(*msgs)
  DbgRb.dbg!(*msgs)
end

DbgRb.color_code = 33 # yellow

alias dbg dbg!
