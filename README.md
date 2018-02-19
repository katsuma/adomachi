# Adomachi

`Adomachi` is util script to scrape "アド街ック天国".

## Usage

```
bundle exec pry -Ilib
```

```ruby
require 'adomachi'
yms = Adomachi::Archive.year_and_months
days = Adomachi::Archive.days(on: yms[0])
program = Adomachi::Program.new(days[0])
program.to_csv(path/to/csv_file)

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katsuma/adomachi.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
