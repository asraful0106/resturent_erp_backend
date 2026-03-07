package owner

import (
	"context"
	"resturent-erp/internal/domain"
	userHandler "resturent-erp/rest/handlers/owner"
)

type Service interface {
	userHandler.Service //Embedding
}

type OwnerRepo interface {
	FindOwnerByEmail(email string) (*domain.Owner, error)
	CreateOwner(ctx context.Context, owner domain.Owner) (*domain.Owner, error)
}
