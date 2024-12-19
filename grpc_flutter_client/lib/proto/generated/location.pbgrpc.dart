//
//  Generated code. Do not modify.
//  source: location.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'location.pb.dart' as $0;

export 'location.pb.dart';

@$pb.GrpcServiceName('location.LocationService')
class LocationServiceClient extends $grpc.Client {
  static final _$sendLocation = $grpc.ClientMethod<$0.Location, $0.LocationResponse>(
      '/location.LocationService/SendLocation',
      ($0.Location value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LocationResponse.fromBuffer(value));
  static final _$subscribeToLocations = $grpc.ClientMethod<$0.SubscribeRequest, $0.Location>(
      '/location.LocationService/SubscribeToLocations',
      ($0.SubscribeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Location.fromBuffer(value));

  LocationServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.LocationResponse> sendLocation($0.Location request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendLocation, request, options: options);
  }

  $grpc.ResponseStream<$0.Location> subscribeToLocations($0.SubscribeRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$subscribeToLocations, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('location.LocationService')
abstract class LocationServiceBase extends $grpc.Service {
  $core.String get $name => 'location.LocationService';

  LocationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Location, $0.LocationResponse>(
        'SendLocation',
        sendLocation_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Location.fromBuffer(value),
        ($0.LocationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.Location>(
        'SubscribeToLocations',
        subscribeToLocations_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.Location value) => value.writeToBuffer()));
  }

  $async.Future<$0.LocationResponse> sendLocation_Pre($grpc.ServiceCall call, $async.Future<$0.Location> request) async {
    return sendLocation(call, await request);
  }

  $async.Stream<$0.Location> subscribeToLocations_Pre($grpc.ServiceCall call, $async.Future<$0.SubscribeRequest> request) async* {
    yield* subscribeToLocations(call, await request);
  }

  $async.Future<$0.LocationResponse> sendLocation($grpc.ServiceCall call, $0.Location request);
  $async.Stream<$0.Location> subscribeToLocations($grpc.ServiceCall call, $0.SubscribeRequest request);
}
