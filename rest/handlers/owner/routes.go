package owner

import (
	"net/http"
	"resturent-erp/rest/middlewares"
)

func (h *Handler) RegisterRoutes(mux *http.ServeMux, manager *middlewares.Manager) {
	// Create owner
	mux.Handle("POST /owner", manager.With(
		http.HandlerFunc(h.CreateOwner),
	))
}
