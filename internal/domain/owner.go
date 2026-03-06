package domain

import (
	"fmt"
	"time"

	"github.com/google/uuid"
)

type Role string

const (
	RoleSuperAdmin Role = "SUPER_ADMIN"
	RoleAdmin      Role = "ADMIN"
	RoleUser       Role = "USER"
)

var AllRoles = []string{
	string(RoleSuperAdmin),
	string(RoleAdmin),
	string(RoleUser),
}

func ParseRole(s string) (Role, error) {
	switch s {
	case string(RoleSuperAdmin):
		return RoleSuperAdmin, nil
	case string(RoleAdmin):
		return RoleAdmin, nil
	case string(RoleUser):
		return RoleUser, nil
	default:
		return "", fmt.Errorf("invalid role: %s", s)
	}
}

// Used for creating owner
type Owner struct {
	Id           uuid.UUID `json:"id" db:"id"`
	Name         string    `json:"name" db:"name"`
	Email        string    `json:"email" db:"email"`
	Phone        string    `json:"phone" db:"phone"`
	PasswordHash string    `json:"password_hash" db:"password_hash"`
	Role         Role      `json:"role" db:"role"`
	DeletedAt    time.Time `json:"deleted_at" db:"deleted_at"`
	CreatedAt    time.Time `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time `json:"updated_at" db:"updated_at"`
}

// Used for updating owner information
type UpdateOwner struct {
	Name         *string `json:"name,omitempty"`
	Email        *string `json:"email,omitempty"`
	Phone        *string `json:"phone,omitempty"`
	PasswordHash *string `json:"password_hash,omitempty"`
	Role         *Role   `json:"role,omitempty"`
}

// Public owner data (safe to expose)
type PublicOwner struct {
	Id        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Phone     string    `json:"phone"`
	Role      Role      `json:"role"`
	CreatedAt time.Time `json:"created_at"`
}
