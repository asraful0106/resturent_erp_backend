package utils

import (
	"encoding/json"
	"net/http"
)

type DataObj struct {
	Success    bool        `json:"success"`
	Message    string      `json:"message"`
	Data       interface{} `json:"data"`
	StatusCode int         `json:"status_code"`
}

func DataResponse(w http.ResponseWriter, data interface{}, statusCode int, message string) {
	updatedData := DataObj{
		Success:    true,
		Message:    message,
		Data:       data,
		StatusCode: statusCode,
	}
	w.WriteHeader(statusCode);
	json.NewEncoder(w).Encode(updatedData);
}