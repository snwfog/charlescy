require 'statsd-instrument'

StatsD.backend = StatsD::Instrument::Backends::UDPBackend.new("statsd.hostedgraphite.com:8125", :statsd)
StatsD.prefix = "ccdbadec-4d02-4f3e-98f8-5f41b99ff741"
