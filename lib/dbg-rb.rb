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
      loc = caller_locations.first(3).last.to_s
      matching_loc = loc.match(/.+(rb)\:\d+\:(in)\s/)
      src = if !matching_loc.nil?
          matching_loc[0][0..-5]
        else
          loc
        end
      file, line = src.split(":")
      file = file.split("/").last(2).join("/")
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
              ":#{obj}"
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

    def colorize(str, color_code)
      "\e[#{color_code}m#{str}\e[0m"
    end

    def format_val(val)
      if val.nil?
        "nil"
      elsif val.is_a?(String)
        "\"#{val}\""
      elsif val.is_a?(Hash) || val.is_a?(Array)
        JSON.pretty_generate(val)
      else
        val
      end
    end
  end
end

def dbg!(*msgs)
  DbgRb.dbg!(*msgs)
end

DbgRb.color_code = 33 # yellow

alias dbg dbg!
