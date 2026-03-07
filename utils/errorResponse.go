package utils

import (
	"encoding/json"
	"log"
	"net/http"
)

type ErrorObj struct {
	Success    bool        `json:"success"`
	Message    string      `json:"message"`
	StatusCode int         `json:"status_code"`
	Error      interface{} `json:"error,omitempty"`
}

func (dependency *Dependency) ErrorResponse(w http.ResponseWriter, err interface{}, statusCode int, errMsg string) {

	if(dependency.cfg.Environment == "development"){
		log.Println("Error: ", err);
	}

	var errorDetail interface{}
	if dependency.cfg.Environment == "development" {
		errorDetail = err;
	} else {
		errorDetail = nil;
	}

	updatedError := ErrorObj{
		Success:    false,
		Message:    errMsg,
		StatusCode: statusCode,
		Error:      errorDetail,
	}

	w.WriteHeader(statusCode);
	json.NewEncoder(w).Encode(updatedError);
}