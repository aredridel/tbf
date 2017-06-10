# A rate limiting module using redis

## Use

```
require 'tbf'
require 'redis'

redis = Redis.new(...)
tbf = TBF.new(redis)

tbf.limit('a key', 20) do 
    # action to be limited here
end
```

## Todo

* tests
* proper publication
* a real readme
* no debugging output
