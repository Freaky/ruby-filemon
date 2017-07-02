# Filemon

This is a Ruby interface to Free/NetBSD's [filemon(4)][1] device, which allows for tracing
of file operations of a process and its children.

It is not a security tool, but intended for auditing processes for determining
file dependencies.

One example of real-world practical use is for accelerating [FreeBSD][2]/[NetBSD][3] world building
using [bmake's meta mode][4].

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

The `filemon` device works by writing tracing data to a file descriptor.  For the
time being, this interface only provides a means of configuring that, what you do
with the result is up to you.

You may need to `kldload filemon` before any of this works.

To monitor a forked process, this mirrors the code documented in the FreeBSD man page:

```ruby
monitor = Filemon::Device.new
monitor.fd = File.new('filemon.out', 'w')

pid = fork do
  monitor.pid = $$
  # Do something here.
end

Process.waitpid(pid)
monitor.close
```

But nothing stops you from simply monitoring the current process:

```ruby
monitor = Filemon::Device.new(fd: STDERR, pid: $$)
# Do something here.
monitor.close
```

Or indeed any pid your user has permission to trace.

A simple command-line tool is provided for tracing commands:

    % bin/filemon sleep 1
    # filemon version 5
    # Target pid 53942
    # Start 1497269126.786684
    V 5
    E 65204 /bin/sleep
    R 65204 /etc/libmap.conf
    R 65204 /usr/local/etc/libmap.d
    R 65204 /var/run/ld-elf.so.hints
    R 65204 /lib/libc.so.7
    X 65204 0 0
    # Stop 1497269127.857683
    # Bye bye

And one for monitoring pids:

    % bin/filemonpid PID [PID2 [...]]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freaky/ruby-filemon.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[1]: https://www.freebsd.org/cgi/man.cgi?query=filemon&sektion=4
[2]: http://freebsd.1045724.x6.nabble.com/CFT-WITH-META-MODE-Working-incremental-build-td6101876.html
[3]: http://www.crufty.net/sjg/docs/netbsd-meta-mode.htm
[4]: http://www.crufty.net/help/sjg/bmake-meta-mode.htm
