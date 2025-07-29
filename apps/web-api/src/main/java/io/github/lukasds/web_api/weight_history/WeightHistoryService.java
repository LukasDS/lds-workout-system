package io.github.lukasds.web_api.weight_history;

import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class WeightHistoryService {
  private final WeightHistoryGrpcClient weightHistoryGrpcClient;

  public WeightHistoryService (WeightHistoryGrpcClient weightHistoryGrpcClient) {
    this.weightHistoryGrpcClient = weightHistoryGrpcClient;
  }

  @Async
  public CompletableFuture<List<WeightHistoryModel>> getWeightHistories() {
    return weightHistoryGrpcClient.getWeightHistories();
  }
}
