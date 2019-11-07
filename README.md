# resty-counter
> Simple high-performance hit/impression counter

resty-counter is a userful/powerful SaaS tool.  Every SaaS will need something cheap to track hit/impression and provide reporting to the client.

We use redis to provide **live** counter data.  The formula for getting **live** counter is: 

{aggregated log data} + {redis data} = {!!! profit !!!}

* daily backup to s3
* weekly update of maxmind geoip2 database

# TECH STACK
* **openresty** - use to create daily log files in the format "yyyy-mm-dd-access.log" and daily cron sync to "s3://bucket-name/year=yyyy/month=mm/day=dd/yyyy-mm-dd-access.log"
* **redis** - store 24-48 hours worth of counter.  This allow for 0-24 hours  delay between log processing.
* **lua-resty-auto-ssl** - for letsencrypt certificate; because, you know, the web is more secure now?

# USAGE

To create impression, simply hit the pixel url: 
```shell
https://pi.example.com/p/tenantcode/counterid
# response: empty gif/pixel
```

To lookup impression/count in the last 24-48 hours: 

```shell
https://pi.example.com/p-query/tenantcode/counterid?apikey=resty-counter
# response: todayCount, yesterdayCount
```

Docker environment variable and examples:
```shell
--env ALLOWED_DOMAINS='(pi.example.com|pixel.example.com)' \
--env AWS_ACCESS_KEY_ID=<<YOUR_ACCESS_KEY>> \
--env AWS_SECRET_ACCESS_KEY=<<YOUR_SECRET_ACCESS>> \
--env AWS_DEFAULT_REGION=us-west-2 \
--env AWS_PATH=bucketname/rootfolder
--env REDIS_HOST=redis-host-name
--env REDIS_AUTH=redis-auth-password
--env REDIS_EXPIRE_DAYS=3
--env API_KEY=pass-this-in-querystring-as-{apikey}
```

- `REDIS_EXPIRE_DAYS` - (default is 3) - set this to a number of days you want to store your counter.  Example where you want to store it for, let say 1 month or 31 days max.  This allow you to write some custom redis query to get your entire counter value from redis.  Set to any value greater than 9999 days to disable expiration.

## Suggestion
You can setup something with AWS Lambda to trigger on s3 event and immediately process the log file.  Of course, once you hit a certain threshold, there are many limitations with Lambda.  The tip/trick here is to use AWS Athena since we already sending into s3 in the format that can be consumed by Athena.

# NOTE
This tool was not created for tracking user on the internet; though, it is possible to do so.  You would have to modify the nginx config and turn on userid stuff, see: http://nginx.org/en/docs/http/ngx_http_userid_module.html

Alternative, you can piggyback your user tracking pixel using our forward/redirect (redir query parameter) feature: https://github.com/niiknow/resty-counter/blob/master/rootfs/usr/local/openresty/nginx/utils.lua#L11

# MIT

