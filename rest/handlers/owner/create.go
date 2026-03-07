package owner

import (
	"encoding/json"
	"fmt"
	"net/http"
	"resturent-erp/internal/domain"
	"resturent-erp/utils"

	"github.com/go-playground/validator/v10" //validation pacakge
)

type ReqOwner struct {
	Name         string `json:"name" validate:"required"`
	Email        string `json:"email" validate:"required,email"`
	Phone        string `json:"phone" validate:"required"`
	PasswordHash string `json:"password_hash" validate:"required,min=8"`
	// Role         *string `json:"role" validate:"omitempty,oneof=SUPER_ADMIN ADMIN USER"`
}

func (h *Handler) CreateOwner(w http.ResponseWriter, r *http.Request) {
	var newOwner ReqOwner
	err := json.NewDecoder(r.Body).Decode(&newOwner)
	if err != nil {
		h.dependecyUtils.ErrorResponse(w, err, http.StatusBadRequest, "Invalid json!")
		return
	}

	// 🔒 REQUIRED FIELDS CHECK
	validate := validator.New()
	if err := validate.Struct(newOwner); err != nil {
		errs := err.(validator.ValidationErrors)
		h.dependecyUtils.ErrorResponse(
			w,
			errs,
			http.StatusBadRequest,
			fmt.Sprintf("%v", errs),
		)
		return
	}

	isOwnerExist, err := h.svc.FindOwnerByEmail(newOwner.Email)

	if err != nil {
		h.dependecyUtils.ErrorResponse(w, err, http.StatusInternalServerError, "Unable to create user.")
		return
	}

	if isOwnerExist.Email != "" {
		h.dependecyUtils.ErrorResponse(w, err, http.StatusConflict, "User already exist.")
		return
	}

	ctx := r.Context()

	createOwner, err := h.svc.CreateOwner(ctx, domain.Owner{
		Name:         newOwner.Name,
		Email:        newOwner.Email,
		Phone:        newOwner.Phone,
		PasswordHash: newOwner.PasswordHash,
	})

	if err != nil {
		h.dependecyUtils.ErrorResponse(w, err, http.StatusInternalServerError, "Unable to create user.")
		return
	}
	if createOwner == nil {
		h.dependecyUtils.ErrorResponse(w, nil, http.StatusInternalServerError, "User creation failed.")
		return
	}
	utils.DataResponse(w, domain.PublicOwner{
		Id:    createOwner.Id,
		Name:  createOwner.Name,
		Phone: createOwner.Phone,
		Email: createOwner.Email,
		Role:  createOwner.Role,
	}, http.StatusCreated, "User created successfully.")
}
