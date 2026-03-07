package middlewares

import (
	"resturent-erp/configs"
	"resturent-erp/utils"
)

type Dipendency struct {
	cfg *configs.Config
	utilsDependecy *utils.Dependency
}

func NewDipendency(
	cfg *configs.Config,
	utilsDependecy *utils.Dependency,
	) *Dipendency{
	return &Dipendency{
		cfg: cfg,
		utilsDependecy: utilsDependecy,
	}
}