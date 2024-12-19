# dbg! [![Gem Version](https://badge.fury.io/rb/dbg-rb.svg)](https://badge.fury.io/rb/dbg-rb) [![GH Actions](https://github.com/pawurb/dbg-rb/actions/workflows/ci.yml/badge.svg)](https://github.com/pawurb/dbg-rb/actions)

![Dbg base](https://github.com/pawurb/dbg-rb/raw/main/dbg_base3.png)
 
Because I wrote: 

```ruby
p '!!!!!!!!!!!!!!!'
p msg
p '!!!!!!!!!!!!!!!'
```

too many times already.
 
`dbg` is a minimal, [Rust inspired](https://doc.rust-lang.org/std/macro.dbg.html), *puts debugging* command for Ruby. It provides caller context and formatting helpful in everyday debugging tasks.

## Installation

`Gemfile`
```ruby
gem "dbg-rb"
```

## Usage

Gem adds a global `dbg` method that you can use for puts debugging:

```ruby
require "dbg-rb"

dbg(User.last.id)
# [web/user_sessions_controller.rb:37] 1972

```

It appends a caller file and line info to the debug output.

You can use symbols to output local variable names together with their values:

```ruby
a = 1
b = 2 

dbg(:a, :b)
# [models/user.rb:22] a = 1
# [models/user.rb:22] b = 2
```

Hash values are pretty printed:

```ruby
user = User.last.as_json
dbg(:user)
# [web/users_controller.rb:10 user = {
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
DbgRb.color_code= nil
```

```ruby
user = User.last.as_json.slice("id", "slack_id")
dbg("User last", :user)
```

![Dbg color](https://github.com/pawurb/dbg-rb/raw/main/dbg_base3.png)

If it does not stand out enough, you can enable `dbg` highlighting:

`config/initializers/dbg_rb.rb`
```ruby
require "dbg-rb"

DbgRb.highlight!("🎉💔💣🕺🚀🧨🙈🤯🥳🌈🦄")
```

![Dbg emoji](https://github.com/pawurb/dbg-rb/raw/main/dbg_emoji2.png)

You can also use `DbgRb.dbg!(*msgs)` directly or wrap it to rename the helper method:

```ruby
def dd(*msgs)
  DbgRb.dbg!(*msgs)
end
```

## Status

Contributions & ideas very welcome!
