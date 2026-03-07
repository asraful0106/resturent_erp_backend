package owner

import (
	"resturent-erp/rest/middlewares"
	"resturent-erp/utils"
)

type Handler struct {
	dependecyUtils      *utils.Dependency
	svc                 Service
	dependecyMiddleware *middlewares.Dipendency
}

func NewHandler(
	dependecyUtils *utils.Dependency,
	svc Service,
	dependecyMiddleware *middlewares.Dipendency) *Handler {
	return &Handler{
		dependecyUtils:      dependecyUtils,
		svc:                 svc,
		dependecyMiddleware: dependecyMiddleware}
}
