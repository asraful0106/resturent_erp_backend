package configs

import (
	"fmt"
	"os"
	"sync"

	// this will automatically load your .env file:
	_ "github.com/joho/godotenv/autoload"
)

type Config struct {
	DB                 PostgresConfig
	Port               string
	Environment        string // development or production
	JWT_SECRET         string
	JWT_EXPIRE         string
	JWT_REFRESH_SECRET string
	JWT_REFRESH_EXPIRE string
	SUPER_ADMIN        SuperAdmin
	MAILER             Mailer
	STORE_SETTING      StoreSetting
}

var (
	cfg  *Config
	once sync.Once
	err  error
)

type PostgresConfig struct {
	Host     string
	Username string
	Password string
	Dbname   string
	Port     string
}

type SuperAdmin struct {
	SUPER_ADMIN_NAME     string
	SUPER_ADMIN_PHONE    string
	SUPER_ADMIN_EMAIL    string
	SUPER_ADMIN_PASSWORD string
}

type Mailer struct {
	MAILER_HOST     string
	MAILER_PORT     string
	MAILER_USERNAME string
	MAILER_PASSWORD string
	MAILER_FROM     string
}

type StoreSetting struct {
	STORE_SETTING_MAX_OTP_PER_DAY string
	STORE_SETTING_SUPPORT_EMAIL   string
}


func requireEnv(key string) string {
	val := os.Getenv(key)
	if val == "" {
		if err == nil {
			err = fmt.Errorf("%s is required", key)
		} else {
			err = fmt.Errorf("%w; %s is required", err, key)
		}
	}
	return val
}

func loadConfig() {
	cfg = &Config{
		Port:        requireEnv("PORT"),
		Environment: requireEnv("ENVIRONMENT"),
		DB: PostgresConfig{
			Host:     requireEnv("POSTGRES_HOST"),
			Username: requireEnv("POSTGRES_USER"),
			Password: requireEnv("POSTGRES_PWD"),
			Dbname:   requireEnv("DB_NAME"),
			Port:     requireEnv("POSTGRES_PORT"),
		},
		JWT_SECRET:         requireEnv("JWT_SECRET"),
		JWT_EXPIRE:         requireEnv("JWT_EXPIRE"),
		JWT_REFRESH_SECRET: requireEnv("JWT_REFRESH_SECRET"),
		JWT_REFRESH_EXPIRE: requireEnv("JWT_REFRESH_EXPIRE"),
		SUPER_ADMIN: SuperAdmin{
			SUPER_ADMIN_NAME:     requireEnv("SUPER_ADMIN_NAME"),
			SUPER_ADMIN_PHONE:    requireEnv("SUPER_ADMIN_PHONE"),
			SUPER_ADMIN_EMAIL:    requireEnv("SUPER_ADMIN_EMAIL"),
			SUPER_ADMIN_PASSWORD: requireEnv("SUPER_ADMIN_PASSWORD"),
		},
		MAILER: Mailer{
			MAILER_HOST:     requireEnv("MAILER_HOST"),
			MAILER_PORT:     requireEnv("MAILER_PORT"),
			MAILER_USERNAME: requireEnv("MAILER_USERNAME"),
			MAILER_PASSWORD: requireEnv("MAILER_PASSWORD"),
			MAILER_FROM:     requireEnv("MAILER_FROM"),
		},
		STORE_SETTING: StoreSetting{
			STORE_SETTING_MAX_OTP_PER_DAY: requireEnv("STORE_SETTING_MAX_OTP_PER_DAY"),
			STORE_SETTING_SUPPORT_EMAIL: requireEnv("STORE_SETTING_SUPPORT_EMAIL"),
		},
	}
}

func GetConfig() (*Config, error) {
	once.Do(loadConfig)
	return cfg, err
}