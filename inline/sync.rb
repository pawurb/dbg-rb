#!/usr/bin/env ruby

require "fileutils"

FileUtils.cp("lib/dbg-rb.rb", "inline/dbg_rb.rb")

license = <<~LICENSE
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
LICENSE

File.write("inline/dbg_rb.rb", File.read("inline/dbg_rb.rb").sub(/\A# frozen_string_literal: true\n/, "# frozen_string_literal: true\n\n#{license}"))

FileUtils.cp("spec/main_spec.rb", "spec/inline_spec.rb")

File.write("spec/inline_spec.rb", File.read("spec/inline_spec.rb").gsub(/main_spec/, "inline_spec").gsub("require \"dbg-rb\"", "require_relative '../inline/dbg_rb'"))
