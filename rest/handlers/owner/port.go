package owner

import (
	"context"
	"resturent-erp/internal/domain"
)

type Service interface {
	FindOwnerByEmail(email string) (*domain.Owner, error)
	CreateOwner(ctx context.Context, owner domain.Owner) (*domain.Owner, error)
}