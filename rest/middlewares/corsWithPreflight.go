package middlewares

import "net/http"

func CorsWithPreflight(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request){
		// Handlers Cors
		w.Header().Set("Access-Control-Allow-Origin", "*");
		w.Header().Set("Content-Type", "application/json");
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS");
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type");
		w.Header().Set("Content-Type", "application/json");

		// Handle preflight request
		if(r.Method == "OPTIONS"){
			w.WriteHeader(200);
			return;
		}

		next.ServeHTTP(w, r);
	});
}