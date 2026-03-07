package owner

import (
	"context"
	"resturent-erp/internal/domain"
)

type service struct {
	ownerRepo OwnerRepo
}

func NewService(ownerRepo OwnerRepo) Service {
	return &service{
		ownerRepo: ownerRepo,
	}
}

func (svc *service) CreateOwner(ctx context.Context, owner domain.Owner) (*domain.Owner, error) {
	cteateOwner, err := svc.ownerRepo.CreateOwner(ctx, owner)

	if err != nil {
		return nil, err
	}
	if cteateOwner == nil {
		return nil, nil
	}
	return cteateOwner, nil
}
