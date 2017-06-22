module Filemon
  Operation = Struct.new(:operation, :pid, :args)

  class Parser
    def initialize(io)
      @io = io
    end

    def each
      return enum_for(__method__) unless block_given?

      @io.each_line do |line|
        op = case line[0]
        when 'V' # version:                          V 5
        when 'A' # openat                            A 57489 moo
        when 'C' # chdir:                            C 46839 /etc
        when 'D' # unlink:                           D 54423 abc
        when 'E' # exec:                             E 42567 /bin/mv
        when 'F' # fork, vfork:                      F 46839 47343
        when 'L' # link, linkat, symlink, symlinkat: L 21745 'a' 'b'
        when 'M' # rename:                           M 42567 'a' 'b'
        when 'R' # open, openat for read:            R 42567 /etc/libmap.conf
        when 'W' #              for write:           W 46839 abc
        when 'X' # _exit:                            X 42567 0 0
        end
      end
    end
  end
end
