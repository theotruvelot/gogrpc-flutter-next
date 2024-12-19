package main

import (
	"context"
	"log"

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

	req := &pb.SubscribeRequest{
		SubscriberId: "receiver_1",
	}

	stream, err := client.SubscribeToLocations(context.Background(), req)
	if err != nil {
		log.Fatalf("Error subscribing to locations: %v", err)
	}

	log.Println("Waiting for locations...")
	for {
		location, err := stream.Recv()
		if err != nil {
			log.Printf("Error receiving location: %v", err)
			break
		}

		log.Printf("Received location - Device: %s, Lat: %f, Long: %f, Time: %d",
			location.DeviceId,
			location.Latitude,
			location.Longitude,
			location.Timestamp)
	}
}
