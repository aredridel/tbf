class TBF

	def initialize(redis)
		@redis = redis
	end

	def limit(key, rate, &block)
		lkey = "limit_#{key}"
		tkey = "ts_#{key}"

		wait = loop do

			now = Time.now.to_f

			@redis.watch(lkey, tkey)

			limit, ts = @redis.mget(lkey, tkey)
			limit = limit.to_f || 0
			ts = ts.to_f || Time.now.to_f

			elapsed = now - ts

			level = [0, limit - elapsed * rate].max

			wait = level.to_f / rate

			p 'start'
			p limit, level, elapsed * rate, wait
			p 'end'

			@redis.multi

			limit = level + 1

			@redis.mset(lkey, limit.to_s, tkey, now.to_s)

			break wait if @redis.exec
		end

		sleep wait

		block.call

	end

end
