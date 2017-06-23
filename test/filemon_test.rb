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
end
