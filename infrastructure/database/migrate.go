package database

import (
	"log"
	"os"

	"github.com/jmoiron/sqlx"
	"github.com/rubenv/sql-migrate"
)

func MigrateDB(db *sqlx.DB, dir string, environment string) error {
	migrations := &migrate.FileMigrationSource{
		Dir: dir,
	}

	// DEBUG: where are we and what migrations are found?
	if environment == "development" {
		wd, _ := os.Getwd()
		log.Println("Working directory:", wd)

		ms, err := migrations.FindMigrations()
		if err != nil {
			log.Println("FindMigrations error:", err)
		} else {
			log.Printf("Found %d migration file(s).\n", len(ms))
			for _, m := range ms {
				log.Println("Migration ID:", m.Id)
			}
		}
	}

	n, err := migrate.Exec(db.DB, "postgres", migrations, migrate.Up)
	if err != nil {
		if environment == "development" {
			log.Println("Migration error:", err)
		}
		return err
	}

	if environment == "development" {
		log.Printf("Applied %d migration(s).\n", n)
	}
	return nil
}