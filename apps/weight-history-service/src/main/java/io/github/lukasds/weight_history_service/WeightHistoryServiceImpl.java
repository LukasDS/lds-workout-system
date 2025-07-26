package io.github.lukasds.weight_history_service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.springframework.stereotype.Service;

import com.google.protobuf.Timestamp;

import io.grpc.stub.StreamObserver;
import weight_history_service.WeightHistoryServiceGrpc;
import weight_history_service.WeigthHistory.GetWeightHistoriesRequest;
import weight_history_service.WeigthHistory.GetWeightHistoriesResponse;
import weight_history_service.WeigthHistory.WeightHistory;
import weight_history_service.WeigthHistory.WeightHistoryEntry;

@Service
public class WeightHistoryServiceImpl extends WeightHistoryServiceGrpc.WeightHistoryServiceImplBase {
  private final WeightHistoryService weightHistoryService;

  public WeightHistoryServiceImpl(WeightHistoryService weightHistoryService) {
    this.weightHistoryService = weightHistoryService;
  }

  @Override
  public void getWeightHistories(GetWeightHistoriesRequest request, StreamObserver<GetWeightHistoriesResponse> responseObserver) {
    List<WeightHistoryModel> weightHistoryModels;
    try {
      weightHistoryModels = weightHistoryService.getWeightHistories();
    } catch (ExecutionException | InterruptedException e) {
      responseObserver.onError(e);
      return;
    }

    var weightHistories = new ArrayList<WeightHistory>();
    for (WeightHistoryModel weightHistoryModel : weightHistoryModels) {
      var weightHistoryEntries = new ArrayList<WeightHistoryEntry>();
      for (WeightHistoryEntryModel weightHistoryEntryModel : weightHistoryModel.getEntries()) {
        Instant instant = weightHistoryEntryModel.getTimestamp().toInstant();
        var timestamp = Timestamp.newBuilder()
          .setSeconds(instant.getEpochSecond())
          .setNanos(instant.getNano())
          .build();

        var weightHistoryEntry = WeightHistoryEntry.newBuilder()
          .setValue(weightHistoryEntryModel.getValue())
          .setTimestamp(timestamp)
          .build();

        weightHistoryEntries.add(weightHistoryEntry);
      }

      var weightHistory = WeightHistory.newBuilder()
        .setWeightName(weightHistoryModel.getWeightName())
        .addAllEntries(weightHistoryEntries)
        .build();

      weightHistories.add(weightHistory);
    }

    var response = GetWeightHistoriesResponse.newBuilder()
      .addAllWeightHistories(weightHistories)
      .build();

    responseObserver.onNext(response);
    responseObserver.onCompleted();
  }
  
}
