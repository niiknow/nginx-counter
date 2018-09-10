# resty-counter
> Simple high-performance hit/impression counter

RESTY-COUNTER is a userful/powerful SaaS toolkit.  Every SaaS will need something cheap to track hit/impression and provide reporting to the client.

# TECH STACK
* **openresty** - use to create daily log files in the format "yyyy-mm-dd-access.log" and daily cron sync to "s3://bucket-name/year=yyyy/month=mm/day=dd/yyyy-mm-dd-hh_access.log"
* **redis** - store 24-48 hours worth of counter.  This allow for 0-24 hours  delay between log processing.
* **lua-resty-auto-ssl** - for letsencrypt certificate; because, you know, the web is more secure now?

# USAGE

To create impression, simply hit the pixel url: 
```shell
https://pi.example.com/t/tenantcode/counterid
# response: empty gif/pixel
```

To lookup impression/count in the last 24-48 hours: 

```shell
https://pi.example.com/lookup/tenantcode/counterid
# response: todayCount, yesterdayCount
```

Docker environment variable and examples:
```shell
--env DOMAINS='(pi.example.com|pixel.example.com)' \
--env AWS_ACCESS_KEY_ID=<<YOUR_ACCESS_KEY>> \
--env AWS_SECRET_ACCESS_KEY=<<YOUR_SECRET_ACCESS>> \
--env AWS_DEFAULT_REGION=us-west-2 \
--env AWS_PATH=bucketname/rootfolder
```

## Suggestion
You can setup something with AWS Lambda to trigger on s3 event and immediately process the log file.  Of course, once you hit a certain threshold, there are many limitations with Lambda.  The tip/trick here is to use AWS Athena since we already sending into s3 in the format that can be consumed by Athena.

# NOTE
This tool was not created for tracking user on the internet; though, it is possible to do so.  You would have to modify the nginx config and turn on userid stuff, see: http://nginx.org/en/docs/http/ngx_http_userid_module.html

Alternative, you can piggyback your user tracking pixel using our forward/redirect (redir query parameter) feature: https://github.com/niiknow/resty-counter/blob/master/rootfs/usr/local/openresty/nginx/utils.lua#L11

# MIT

