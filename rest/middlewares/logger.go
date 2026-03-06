package middlewares

import (
	"log"
	"net"
	"net/http"
	"time"
)

func Logger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request){
		startTime := time.Now();
		next.ServeHTTP(w, r);
		// log.Println("# ","Method: ", " Execution Time: ", time.Since(startTime));
		log.Println("# ","Method: ", r.Method," Route: ", r.URL.Path, " UserAgent: ", r.UserAgent(), "IP: ", getClientIP(r), " Execution Time: ", time.Since(startTime));
	});
}

func getClientIP(r *http.Request) string {
	// Check X-Forwarded-For (if behind proxy/load balancer)
	if xff := r.Header.Get("X-Forwarded-For"); xff != "" {
		return xff
	}

	// Check X-Real-IP
	if xrip := r.Header.Get("X-Real-IP"); xrip != "" {
		return xrip
	}

	// Fallback to RemoteAddr
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		return r.RemoteAddr
	}
	return host
}