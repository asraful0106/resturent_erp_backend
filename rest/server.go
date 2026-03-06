package rest

import (
	"fmt"
	"log"
	"net/http"
	"resturent-erp/configs"
	"resturent-erp/rest/middlewares"
)

type Server struct {
	cfg *configs.Config
}

func NewServer(cfg *configs.Config) *Server {
	return &Server{cfg: cfg}
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
        }
        w.Header().Set("Content-Type", "application/json")
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
    // server.authHandler.RegisterRoutes(mux, manager)
    // server.userHandler.RegisterRoutes(mux, manager)
    // server.productHandler.RegisterRoutes(mux, manager)
    // server.branchHandler.RegisterRoutes(mux, manager)
    // server.employeeHandler.RegisterRoutes(mux, manager)
}