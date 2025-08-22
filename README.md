# dbg [![Gem Version](https://badge.fury.io/rb/dbg-rb.svg)](https://badge.fury.io/rb/dbg-rb) [![GH Actions](https://github.com/pawurb/dbg-rb/actions/workflows/ci.yml/badge.svg)](https://github.com/pawurb/dbg-rb/actions)

![Dbg base](https://github.com/pawurb/dbg-rb/raw/main/dbg_base2.png)
 
Because I wrote: 

```ruby
p '!!!!!!!!!!!!!!!'
p msg
p '!!!!!!!!!!!!!!!'
```

too many times already.
 
`dbg` is a minimal, [Rust inspired](https://doc.rust-lang.org/std/macro.dbg.html), *puts debugging* command for Ruby. It provides caller context and formatting helpful in everyday debugging tasks.

## Installation

`bundle add dbg-rb`

Alternatively, you can use an inline version of `dbg-rb` without adding it to the Gemfile. Check out [this post](https://pawelurbanek.com/rails-puts-debug#inline-setup) for info on how to do it.

## Usage

Gem adds a global `dbg` method that you can use for puts debugging:

```ruby
require "dbg-rb"

dbg(User.last.id)
# [web/user_sessions_controller.rb:37] User.last.id = 1972

```

It appends a caller file, line info and source expression to the debug output.


Hash values are pretty printed:

```ruby

dbg(User.last.as_json)
# [web/users_controller.rb:10] User.last.as_json = {
#   "id": 160111,
#   "team_id": 1,
#   "pseudonym": "Anonymous-CBWE",
#   ...
# }
```

You can color the output:

`config/initializers/dbg_rb.rb`
```ruby
require "dbg-rb"

DbgRb.color_code = 33 
# 31 red 
# 32 green 
# 33 yellow 
# 34 blue 
# 35 pink 
# 36 light blue
```

It's yellow by default. You can disable colors by running:

```ruby
DbgRb.color_code = nil
```

```ruby
dbg(User.last(2).map(&:as_json))
```

![Dbg color](https://github.com/pawurb/dbg-rb/raw/main/dbg_base2.png)

If it does not stand out enough, you can enable `dbg` highlighting:

`config/initializers/dbg_rb.rb`
```ruby
require "dbg-rb"

DbgRb.highlight!("🎉💔💣🕺🚀🧨🙈🤯🥳🌈🦄")
```

![Dbg emoji](https://github.com/pawurb/dbg-rb/raw/main/dbg_emoji.png)

## Logs integration

![Lbg logs](https://github.com/pawurb/dbg-rb/raw/main/lbg_logs.png)

Use `lbg` to send debug output through a logger instead of `stdio`:

```ruby
require "dbg-rb"

lbg(User.last.id)
# Sends to Rails.logger.debug: [web/user_sessions_controller.rb:37] User.last.id = 1972
```

The `lbg` method:
- Uses `Rails.logger` by default when Rails is available
- Falls back to regular `dbg` behavior if no logger is configured
- Uses `:debug` log level by default

You can configure a custom logger and log level:

```ruby
DbgRb.logger = MyLogger.new
DbgRb.log_level = :info
```

## Status

Contributions & ideas very welcome!
