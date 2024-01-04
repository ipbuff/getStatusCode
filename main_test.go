package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestHandleStatusCode(t *testing.T) {
	tests := []struct {
		urlPath       string
		expectedCode  int
		expectedBody  string
		expectedError int
	}{
		{"/200", http.StatusOK, "OK", http.StatusOK},
		{"/404", http.StatusNotFound, "Not Found", http.StatusOK},
		{"/invalid", http.StatusBadRequest, "Invalid URL format", http.StatusOK},
		{"/999", http.StatusBadRequest, "Invalid status code", http.StatusOK},
		{"/1000", http.StatusBadRequest, "Invalid status code", http.StatusOK},
		{"/-1", http.StatusBadRequest, "Invalid URL format", http.StatusOK},
	}

	for _, test := range tests {
		req, err := http.NewRequest("GET", test.urlPath, nil)
		if err != nil {
			t.Fatal(err)
		}

		recorder := httptest.NewRecorder()
		handleStatusCode(recorder, req)

		// Check status code
		if recorder.Code != test.expectedCode {
			t.Errorf("For URL '%s', expected status code %d, got %d", test.urlPath, test.expectedCode, recorder.Code)
		}

		// Check response body
		if body := recorder.Body.String(); !strings.Contains(body, test.expectedBody) {
			t.Errorf("For URL '%s', expected body '%s', got '%s'", test.urlPath, test.expectedBody, body)
		}
	}
}
