package middlewares

import "net/http"

type Middleware func(http.Handler) http.Handler;

type Manager struct {
	globalMiddleWares [] Middleware
}

func NewManager() *Manager {
	return &Manager{
		globalMiddleWares: make([]Middleware, 0),
	}
}

func (mngr *Manager) Use(middlewares ...Middleware) *Manager{
	mngr.globalMiddleWares = append(mngr.globalMiddleWares, middlewares...);
	return  mngr;
}

func (mngr *Manager) With(next http.Handler, middlewares ...Middleware) http.Handler{
	n := next;

	// Apply route-specific (inner)
	for i := len(middlewares) - 1; i >= 0; i-- {
		n = middlewares[i](n)
	}

	// Apply global (outer)
	for i := len(mngr.globalMiddleWares) - 1; i >= 0; i-- {
		n = mngr.globalMiddleWares[i](n)
	}

	return n;
}