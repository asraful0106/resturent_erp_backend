package database

import (
	"fmt"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func (d *Dependency) GetConnectionString() string {
	return fmt.Sprintf(
		"user=%s password=%s host=%s port=%s dbname=%s sslmode=disable",
		d.cfg.DB.Username,
		d.cfg.DB.Password, 
		d.cfg.DB.Host,
		d.cfg.DB.Port,
		d.cfg.DB.Dbname,
	)
}

func NewConnection(dep *Dependency) (*sqlx.DB, error) {
	dbSource := dep.GetConnectionString()
	dbCon, err := sqlx.Connect("postgres", dbSource)
	if err != nil {
		return nil, err
	}
	
	// Test the connection
	err = dbCon.Ping()
	if err != nil {
		return nil, err
	}
	
	return dbCon, nil
}