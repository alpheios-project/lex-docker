vcl 4.0;

backend default {
  .host = "exist";
  .port = "8080";
  .connect_timeout = 600s;
  .first_byte_timeout = 600s;
  .between_bytes_timeout = 600s;
}

sub vcl_recv {
  unset req.http.Cookie;
  return(hash);
}

sub vcl_deliver {
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }
}

sub vcl_backend_response {
  # eXist jetty always sets the sessionid cookie
  # we just ignore all cookies from the server
  unset beresp.http.set-cookie;

  # Add a grace in case the backend is down
  set beresp.grace = 1h;

  if (beresp.ttl <= 0s) {
    # Varnish determined the object was not cacheable
    set beresp.http.X-Cacheable = "NO:Not Cacheable";
    set beresp.http.X-Cache-TTL = beresp.ttl;
  } else {
      # Varnish determined the object was cacheable
      set beresp.http.X-Cacheable = "YES";
  }
}

