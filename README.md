# Ruby dbg!

Because I wrote: 

```ruby
p '!!!!!!!!!!!!!!!'
p msg
p '!!!!!!!!!!!!!!!'
```

too many times already.
 
`dbg!` is a minimal, [Rust inspired](https://doc.rust-lang.org/std/macro.dbg.html), *puts debugging* command for Ruby. It provides caller context and formatting helpful in everyday debugging tasks.

## Installation

`Gemfile`
```ruby
gem "ruby-dbg"
```

It adds a global `dbg!` method. You can use it for puts debugging:

```ruby
require "ruby-dbg"

dbg!(User.last.id)
# [web/user_sessions_controller.rb:37] 1972

```

It appends relevant caller file and line info to the debug output.

You can use symbols to output local variable names together with their values:

```ruby
a = 1
b = 2 

dbg!(:a, :b)
# [models/user.rb:22] a = 1
# [models/user.rb:22] b = 2
```

Hash values are pretty printed:

```ruby

dbg!(User.last.as_json)
# [web/users_controller.rb:10 {
#   "id": 160111,
#   "team_id": 1,
#   "pseudonym": "Anonymous-CBWE",
#   ...
# }
```

You can enable coloring the output:

`config/initializers/ruby_dbg.rb`
```ruby
require "ruby-dbg"

RubyDBG.color_code = 36 # light blue
# 31 red 
# 32 green 
# 33 yellow 
# 34 blue 
# 35 pink 
```

![Diagnose report](https://github.com/pawurb/ruby-dbg/raw/main/dbg_color.png)

If it does not stand out enough, you can enable `dbg!` highlighting:

```ruby
require "ruby-dbg"

RubyDBG.highlight!("🎉💔💣🕺🚀🧨🙈🤯🥳🌈🦄")
```

![Diagnose report](https://github.com/pawurb/ruby-dbg/raw/main/dbg_emoji.png)

## Status

Contributions & ideas very welcome!
