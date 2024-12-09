# frozen_string_literal: true

require "binding_of_caller"

module RubyDBG
  @@color_code = nil
  @@highlight = false

  def self.color_code=(val)
    @@color_code = val
  end

  def self.highlight!(wrapper = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    @@highlight = wrapper
  end

  def self.colorize(str, color_code)
    "\e[#{color_code}m#{str}\e[0m"
  end

  def self.dbg(*objs)
    loc = caller_locations.first(2).last.to_s
    matching_loc = loc.match(/.+(rb)\:\d+\:(in)\s/)
    src = if !matching_loc.nil?
        matching_loc[0][0..-5]
      else
        loc
      end
    file, line = src.split(":")
    file = file.split("/").last(2).join("/")
    src = "[#{file}:#{line}]"

    objs.each_with_index do |obj, i|
      first = i == 0
      last = i == (objs.size - 1)

      val = if obj.is_a?(Symbol)
          begin
            if (val = binding.of_caller(3).local_variable_get(obj))
              val = format_val(val)

              "#{obj} = #{val}"
            end
          rescue NameError
            ":#{obj}"
          end
        else
          obj
        end

      val = format_val(val)
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
  end

  def self.format_val(val)
    if val.nil?
      "nil"
    elsif val.is_a?(Hash)
      JSON.pretty_generate(val)
    else
      val
    end
  end
end

def dbg!(*objs)
  RubyDBG.dbg(*objs)
  nil
end
