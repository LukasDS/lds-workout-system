package io.github.lukasds.web_api.weight_history;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import weight_history_service.WeightHistoryServiceGrpc;
import weight_history_service.WeightHistoryServiceGrpc.WeightHistoryServiceBlockingStub;
import weight_history_service.WeigthHistory.GetWeightHistoriesRequest;
import weight_history_service.WeigthHistory.GetWeightHistoriesResponse;
import weight_history_service.WeigthHistory.WeightHistory;
import weight_history_service.WeigthHistory.WeightHistoryEntry;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class WeightHistoryGrpcClient {
  @Value("${grpc.client.host}")
  private String host;

  @Value("${grpc.client.port}")
  private int port;

  @Value("${grpc.client.plaintext}")
  private boolean usePlaintext;

  public List<WeightHistoryModel> getWeightHistories() {
    var channelBuilder = ManagedChannelBuilder.forAddress(host, port);
    if (usePlaintext) {
      channelBuilder.usePlaintext();
    }
    ManagedChannel channel = channelBuilder.build();

    WeightHistoryServiceBlockingStub stub = WeightHistoryServiceGrpc.newBlockingStub(channel);

    var request = GetWeightHistoriesRequest.newBuilder().build();
    GetWeightHistoriesResponse response = stub.getWeightHistories(request);

    var weightHistoryModels = new ArrayList<WeightHistoryModel>();
    for (WeightHistory weightHistory : response.getWeightHistoriesList()) {
      var weightHistoryEntryModels = new ArrayList<WeightHistoryEntryModel>();
      for (WeightHistoryEntry weightHistoryEntry : weightHistory.getEntriesList()) {
        Instant instant = Instant.ofEpochSecond(
          weightHistoryEntry.getTimestamp().getSeconds(),
          weightHistoryEntry.getTimestamp().getNanos()
        );
        var timestamp = Date.from(instant);

        var weightHistoryEntryModel = new WeightHistoryEntryModel(weightHistoryEntry.getValue(), timestamp);
        weightHistoryEntryModels.add(weightHistoryEntryModel);
      }

      var weightHistoryModel = new WeightHistoryModel(weightHistory.getWeightName(), weightHistoryEntryModels);
      weightHistoryModels.add(weightHistoryModel);
    }

    channel.shutdown();

    return weightHistoryModels;
  }
}
