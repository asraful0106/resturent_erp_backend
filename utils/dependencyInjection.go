package utils;


import "resturent-erp/configs"

type Dependency struct {
	cfg *configs.Config
}

func NewDependency(cfg *configs.Config) *Dependency{
	return &Dependency{
		cfg: cfg,
	}
}