package owner

import (
	"context"
	"resturent-erp/internal/domain"
)

type Service interface {
	CreateOwner(ctx context.Context, owner domain.Owner) (*domain.Owner, error)
}