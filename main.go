package main

import (
	"fmt"
	"net/http"
	"regexp"
	"strconv"
)

const (
	serverPort = 8080
)

func isValidStatusCode(statusCode int) bool {
	return statusCode >= 100 && statusCode <= 599
}

func handleStatusCode(w http.ResponseWriter, r *http.Request) {
	re := regexp.MustCompile(`^/(\d+)$`)
	matches := re.FindStringSubmatch(r.URL.Path)

	if len(matches) != 2 {
		http.Error(w, "Invalid URL format", http.StatusBadRequest)
		return
	}

	statusCode, err := strconv.Atoi(matches[1])
	if err != nil || !isValidStatusCode(statusCode) {
		http.Error(w, "Invalid status code", http.StatusBadRequest)
		return
	}

	// Responding with the specified status code and status text
	http.Error(w, http.StatusText(statusCode), statusCode)
}

func main() {
	http.HandleFunc("/", handleStatusCode)

	fmt.Printf("Server is running on port '%d'\n", serverPort)
	http.ListenAndServe(fmt.Sprintf(":%d", serverPort), nil)
}
