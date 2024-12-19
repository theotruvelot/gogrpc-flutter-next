package main

import (
	"context"
	"log"
	"time"

	pb "github.com/theotruvelot/grpc-go/proto/location"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func main() {
	conn, err := grpc.NewClient("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect: %v", err)
	}
	defer conn.Close()

	client := pb.NewLocationServiceClient(conn)

	// Simuler l'envoi de positions toutes les 2 secondes
	for {
		location := &pb.Location{
			Latitude:  48.8566, // Paris latitude
			Longitude: 2.3522,  // Paris longitude
			DeviceId:  "device_10",
			Timestamp: time.Now().Unix(),
		}

		resp, err := client.SendLocation(context.Background(), location)
		if err != nil {
			log.Printf("Error sending location: %v", err)
			continue
		}

		log.Printf("Location sent: %v", resp.Message)
		time.Sleep(2 * time.Second)
	}
}
