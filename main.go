package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/mqu/go-notify"
	"github.com/simplereach/timeutils"
)

type AlertManagerRequest struct {
	Receiver          string
	Status            string
	Alerts            []Alert           `json:"Alerts"`
	GroupLabels       map[string]string `json:"GroupLabels"`
	CommonLabels      map[string]string `json:"CommonLabels"`
	CommonAnnotations map[string]string `json:"CommonAnnotations"`
	ExternalURL       string
	Version           string
	GroupKey          string
}

type Alert struct {
	Status       string
	Labels       map[string]string `json:"Labels"`
	Annotations  map[string]string `json:"Annotations"`
	StartsAt     timeutils.Time    `json:"StartsAt"`
	EndsAt       timeutils.Time    `json:"EndsAt"`
	GeneratorURL string
}

func alert(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	var req AlertManagerRequest
	err := decoder.Decode(&req)
	if err != nil {
		http.Error(w, "Bad Request", 400)
	}
	for _, alert := range req.Alerts {
		if alert.Status == "firing" {
			name := alert.Labels["alertname"]
			summary := alert.Annotations["summary"]
			log.Printf("%s: %s\n", name, summary)
			notification := notify.NotificationNew(name, summary, "")
			notification.SetUrgency(2)
			notification.Show()
		}
	}
}

func main() {
	notify.Init("Notification HTTP Server")
	http.HandleFunc("/v1/alerts", alert)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
