A convenience web app to request HTTP Status Codes.

Simply set the path to a status code and the server responds with the requested status code and status text in the body.

## Test
`make test`

## Build
`make build`

## Live
This service can be used at `https://gsc.ipbuff.com/`.

## 404 Example
``` 
curl -i https://gsc.ipbuff.com/404
```

Returns:
```
HTTP/1.1 404 Not Found
Content-Type: text/plain; charset=utf-8
X-Content-Type-Options: nosniff
Date: Thu, 04 Jan 2024 18:24:12 GMT
Content-Length: 10

Not Found
```

## Blog Post
I've written a really short blog post on my personal website on this service. It can be found [here](https://igor.borisoglebski.com/getstatuscode).
