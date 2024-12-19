package main

import (
	"context"
	"log"
	"net"
	"sync"

	pb "github.com/theotruvelot/grpc-go/proto/location"
	"google.golang.org/grpc"
)

type server struct {
	pb.UnimplementedLocationServiceServer
	mu      sync.RWMutex
	clients map[string]chan *pb.Location
}

func newServer() *server {
	return &server{
		clients: make(map[string]chan *pb.Location),
	}
}

func (s *server) SendLocation(ctx context.Context, loc *pb.Location) (*pb.LocationResponse, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	// Broadcast location to all subscribers
	for _, ch := range s.clients {
		select {
		case ch <- loc:
		default:
			// Skip if channel is blocked
		}
	}

	return &pb.LocationResponse{
		Success: true,
		Message: "Location received and broadcast",
	}, nil
}

func (s *server) SubscribeToLocations(req *pb.SubscribeRequest, stream pb.LocationService_SubscribeToLocationsServer) error {
	ch := make(chan *pb.Location, 100)

	s.mu.Lock()
	s.clients[req.SubscriberId] = ch
	s.mu.Unlock()

	defer func() {
		s.mu.Lock()
		delete(s.clients, req.SubscriberId)
		close(ch)
		s.mu.Unlock()
	}()

	for {
		select {
		case loc := <-ch:
			if err := stream.Send(loc); err != nil {
				return err
			}
		case <-stream.Context().Done():
			return nil
		}
	}
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen on port 50051: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterLocationServiceServer(s, newServer())
	log.Printf("gRPC server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
