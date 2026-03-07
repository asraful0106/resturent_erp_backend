package cmd

import (
	"log"
	"os"
	"resturent-erp/configs"
	"resturent-erp/infrastructure/database"
	"resturent-erp/internal/application/owner"
	"resturent-erp/repo"
	"resturent-erp/rest"
	"resturent-erp/rest/middlewares"
	"resturent-erp/utils"

	ownerHandler "resturent-erp/rest/handlers/owner"
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

	// For Utils
	dependencyUtils := utils.NewDependency(cfg)
	// For Middlewares
	dependencyMiddleware := middlewares.NewDipendency(cfg, dependencyUtils)

	// Reopos
	ownerRepo := repo.NewUserRepo(dbConnection)

	// Domains
	ownerSvc := owner.NewService(ownerRepo)

	// Handlers
	ownerHandler := ownerHandler.NewHandler(dependencyUtils, ownerSvc, dependencyMiddleware)

	// Starting the server
	server := rest.NewServer(
		cfg,
		ownerHandler,
	)
	server.StartServer()
}
