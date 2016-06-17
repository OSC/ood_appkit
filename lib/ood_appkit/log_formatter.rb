module OodAppkit
  # format log messages with timestamp severity and app token e.g.:
  #
  #     [2016-06-17 15:31:01 -0400 sys/dashboard]  INFO  GET...
  #
  class LogFormatter
    def call(severity, timestamp, progname, msg)
      severity_d = severity ? severity[0,5].rjust(5).upcase : "UNKNO"
      timestamp_d = timestamp ? timestamp.localtime : Time.now.localtime
      msg_d = (String === msg ? msg.strip : msg.inspect)

      "[#{timestamp_d} #{progname}] #{severity_d} #{msg_d}\n"
    end
  end
end
