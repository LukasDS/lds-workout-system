package io.github.lukasds.web_api.weight_history;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.stub.StreamObserver;
import weight_history_service.WeightHistoryServiceGrpc;
import weight_history_service.WeightHistoryServiceGrpc.WeightHistoryServiceStub;
import weight_history_service.WeigthHistory.GetWeightHistoriesRequest;
import weight_history_service.WeigthHistory.GetWeightHistoriesResponse;

import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

@Component
public class WeightHistoryGrpcClient {
  @Value("${grpc.client.host}")
  private String host;

  @Value("${grpc.client.port}")
  private int port;

  @Value("${grpc.client.plaintext}")
  private boolean usePlaintext;

  @Async
  public CompletableFuture<List<WeightHistoryModel>> getWeightHistories() {
    var channelBuilder = ManagedChannelBuilder.forAddress(host, port);
    if (usePlaintext) {
      channelBuilder.usePlaintext();
    }
    ManagedChannel channel = channelBuilder.build();

    WeightHistoryServiceStub stub = WeightHistoryServiceGrpc.newStub(channel);

    var resultFuture = new CompletableFuture<List<WeightHistoryModel>>();
    var request = GetWeightHistoriesRequest.newBuilder().build();
    stub.getWeightHistories(request, new StreamObserver<GetWeightHistoriesResponse>() {
      @Override
      public void onNext(GetWeightHistoriesResponse value) {
        List<WeightHistoryModel> weightHistoryModels = value.getWeightHistoriesList()
          .stream().map(weightHistory -> {
            List<WeightHistoryEntryModel> entries = weightHistory.getEntriesList().stream().map(entry -> {
              var instant = Instant.ofEpochSecond(
                entry.getTimestamp().getSeconds(),
                entry.getTimestamp().getNanos()
              );
              var timestamp = Date.from(instant);
              return new WeightHistoryEntryModel(entry.getValue(), timestamp);
          }).toList();
          return new WeightHistoryModel(weightHistory.getWeightName(), entries);
        }).toList();

        resultFuture.complete(weightHistoryModels);
      }

      @Override
      public void onError(Throwable t) {
        resultFuture.completeExceptionally(t);
        channel.shutdown();
      }

      @Override
      public void onCompleted() {
        channel.shutdown();
        try {
          channel.awaitTermination(1, TimeUnit.SECONDS);
        } catch (InterruptedException ignore) {}
      }
    });

    channel.shutdown();

    return resultFuture;
  }
}
