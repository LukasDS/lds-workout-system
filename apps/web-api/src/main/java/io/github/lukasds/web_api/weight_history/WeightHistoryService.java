package io.github.lukasds.web_api.weight_history;

import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class WeightHistoryService {
  private final WeightHistoryGrpcClient weightHistoryGrpcClient;

  public WeightHistoryService (WeightHistoryGrpcClient weightHistoryGrpcClient) {
    this.weightHistoryGrpcClient = weightHistoryGrpcClient;
  }

  public List<WeightHistoryModel> getWeightHistories() {
    return weightHistoryGrpcClient.getWeightHistories();
  }
}
