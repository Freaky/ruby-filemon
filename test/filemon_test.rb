require "test_helper"

class FilemonTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Filemon::VERSION
  end

  def test_device_lifecycle
    fm = Filemon::Device.new
    refute fm.closed?
    fm.close
    assert fm.closed?
  end

  def test_self_trace
    r,w = IO.pipe

    fm = Filemon::Device.new(fd: w, pid: $$)
    fm.close
    w.close
    ret = r.readlines

    assert_match(/\A# filemon version 5/, ret.shift)
    assert_match(/\A# Target pid #{$$}/, ret.shift)
  end

  def test_trace
    skip # proposed interface

    trace = Filemon::Trace.new do
      this_file = File.new(__FILE__)
      devnull = File.new('/dev/null', 'w')
      IO.copy_stream(this_file, devnull)
    end

    assert trace.events.one? do |event|
      event.type == :read && event.path == __FILE__
    end

    assert trace.events.one? do |event|
      event.type == :write && event.path == '/dev/null'
    end

    assert trace.files.include? __FILE__
    assert trace.files.include? '/dev/null'

    assert trace.read.include? __FILE__
    assert trace.write.include? '/dev/null'
  end
end

