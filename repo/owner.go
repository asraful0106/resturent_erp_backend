package repo

import (
	"context"
	"database/sql"
	"errors"
	"resturent-erp/internal/application/owner"
	"resturent-erp/internal/domain"
	"resturent-erp/utils"

	"github.com/jmoiron/sqlx"
)

type OwnerRepo interface {
	owner.OwnerRepo // application owner
}

type ownerRepo struct {
	db *sqlx.DB
}

func NewUserRepo(dbConnection *sqlx.DB,
) OwnerRepo {
	return &ownerRepo{
		db: dbConnection,
	}
}

func (u *ownerRepo) CreateOwner(ctx context.Context, owner domain.Owner) (*domain.Owner, error) {
	// Step1: Check is user exist
	var isEmailExist domain.Owner

	emailQuery := `
		SELECT id, email
		FROM owners
		WHERE email = $1;
	`
	err := u.db.Get(&isEmailExist, emailQuery, owner.Email)
	if err != nil && !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}
	if err != nil && isEmailExist.Email != "" {
		return nil, errors.New("Email already exist")
	}

	// has plainttext password
	hashedPassword, err := utils.CreateCiphertext(owner.PasswordHash)
	if err != nil {
		return nil, err
	}

	owner.PasswordHash = hashedPassword

	query := `
		INSERT INTO owners (name, email, phone, password_hash)
		VALUES ($1, $2, $3, $4)
		RETURNING id, name, email, phone, role;
	`

	var createdOwner domain.Owner

	err = u.db.QueryRowContext(ctx, query, owner.Name, owner.Email, owner.Phone, owner.PasswordHash).Scan(&createdOwner.Id, &createdOwner.Name, &createdOwner.Email, &createdOwner.Phone, &createdOwner.Role)
	
	if err != nil {
		return nil, err
	}

	return &createdOwner, nil
}
