require "filemon/version"

module Filemon
  class Device
    def initialize(fd: nil, pid: nil)
      @filemon = File.new('/dev/filemon')
      fd  and self.fd  = fd
      pid and self.pid = pid
    end

    def fd=(fd)
      case fd
      when Integer
      when IO then fd = fd.fileno
      else raise ArgumentError, "fd must be an Integer or IO"
      end

      ptr = [[fd].pack('I')].pack('P').unpack('j!').first
      @filemon.ioctl(IOCCOM::FILEMON_SET_FD, ptr)
    end

    def pid=(pid)
      Integer === pid or raise ArgumentError, "pid must be an Integer"

      ptr = [[pid].pack('I')].pack('P').unpack('j!').first
      @filemon.ioctl(IOCCOM::FILEMON_SET_PID, ptr)
    end

    def close
      @filemon.close
    end
  end

  # sys/ioccom.h
  module IOCCOM
    IOCPARM_SHIFT=   13
    IOCPARM_MASK=    ((1 << IOCPARM_SHIFT) - 1)
    IOC_OUT=         0x40000000
    IOC_IN=          0x80000000
    IOC_INOUT=       (IOC_IN|IOC_OUT)

    def self.iowr(g,n,t)
      ioc(IOC_INOUT, g.ord, n, t)
    end

    def self.ioc(inout,group,num,len)
      ((inout) | (((len) & IOCPARM_MASK) << 16) | ((group) << 8) | (num))
    end

    FILEMON_SET_FD=  IOCCOM.iowr('S', 1, 4)
    FILEMON_SET_PID= IOCCOM.iowr('S', 2, 4)
  end
end
