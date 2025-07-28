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

    List<WeightHistoryModel> weightHistoryModels = response.getWeightHistoriesList()
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

    channel.shutdown();

    return weightHistoryModels;
  }
}
