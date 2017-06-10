require './tbf'
require 'redis'

5.times.map { ||
    Thread.new do
        redis = Redis.new(:host => "127.0.0.1", :port => 6379)

        tbf = TBF.new(redis)

        10.times do
            tbf.limit('key', 20) do
                p Time.now
            end
        end
    end
}.map { |t| t.join }
