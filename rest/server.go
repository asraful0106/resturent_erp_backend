package rest

import (
	"fmt"
	"log"
	"net/http"
	"resturent-erp/configs"
	"resturent-erp/rest/handlers/owner"
	"resturent-erp/rest/middlewares"
)

type Server struct {
	cfg          *configs.Config
	ownerHandler *owner.Handler
}

func NewServer(cfg *configs.Config,
	ownerHandler *owner.Handler) *Server {
	return &Server{
		cfg: cfg, ownerHandler: ownerHandler}
}

func (server *Server) StartServer() {
	rootMux := http.NewServeMux()

	// Global middlewares
	manager := middlewares.NewManager()
	manager.Use(middlewares.Logger)

	// Health check at "/"
	rootMux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			http.NotFound(w, r)
			return
		} // Handlers Cors
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		w.Header().Set("Content-Type", "application/json")

		// Handle preflight request
		if r.Method == "OPTIONS" {
			w.WriteHeader(200)
			return
		}
		fmt.Fprintf(w, `{"message":"Server is running","port":"%s"}`, server.cfg.Port)
	})

	// All API routes under /api/v1/
	apiMux := http.NewServeMux()
	server.registerAPIRoutes(apiMux, manager)
	rootMux.Handle("/api/v1/", http.StripPrefix("/api/v1", apiMux))

	log.Printf("Server is running at port %s\n", server.cfg.Port)
	err := http.ListenAndServe(":"+server.cfg.Port, middlewares.CorsWithPreflight(rootMux))
	if err != nil {
		log.Fatal("Error: ", err)
	}
}

func (server *Server) registerAPIRoutes(mux *http.ServeMux, manager *middlewares.Manager) {
	// Handleing owner routes
	server.ownerHandler.RegisterRoutes(mux, manager)
	// server.userHandler.RegisterRoutes(mux, manager)
	// server.productHandler.RegisterRoutes(mux, manager)
	// server.branchHandler.RegisterRoutes(mux, manager)
	// server.employeeHandler.RegisterRoutes(mux, manager)
}
