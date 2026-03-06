package cmd

import (
	"log"
	"os"
	"resturent-erp/configs"
	"resturent-erp/infrastructure/database"
	"resturent-erp/rest"
)

func Serve() {
	//loading .env
	cfg, cfgErr := configs.GetConfig()
	if cfgErr != nil {
		if cfg.Environment == "development" {
			log.Println("Config Error: ", cfgErr)
		}
		os.Exit(1)
	}

	// Connecting to DB
	dependencyDatabase := database.NewDependency(cfg)
	dbConnection, dbErr := database.NewConnection(dependencyDatabase)
	if dbErr != nil {
		if cfg.Environment == "development" {
			log.Println("Faild to connect DB: ", dbErr)
		}
		os.Exit(1)
	}

	// Seeding Supper Admin
	// repo.SeedSuperAdmin(dbConnection, cfg)

	// Migration
	database.MigrateDB(dbConnection, "./infrastructure/database/migrations", cfg.Environment)

	// Starting the server
	server := rest.NewServer(
		cfg,
	)
	server.StartServer()
}
