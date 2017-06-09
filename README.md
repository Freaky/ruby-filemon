# Filemon

This is an interface to FreeBSD's [filemon(4)][1] device, which allows for tracing
of file operations of a process and its children.

It is not a security tool, but intended for auditing processes for determining
file dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'filemon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filemon

## Usage

To monitor a forked process, this mirrors the code documented in the FreeBSD man page:

```ruby
monitor = Filemon::Device.new
monitor.fd = File.new('file_access.log', 'w')

pid = fork do
	monitor.pid = $$
	require 'foo'
	system "bar" # also gets traced
end

Process.waitpid(pid)
monitor.close
```

But this works too if you want to self-monitor:

```ruby
monitor = Filemon::Device.new(fd: STDERR, pid: $$)
# ...
monitor.close
```

And if you're root you can montor arbitrary pids.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freaky/filemon.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

1: https://www.freebsd.org/cgi/man.cgi?query=filemon&sektion=4
