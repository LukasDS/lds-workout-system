package io.github.lukasds.weight_history_service;

import java.util.List;
import java.util.concurrent.ExecutionException;

import org.springframework.stereotype.Service;

@Service
public class WeightHistoryService {
  private final WeightHistoryRepository weightHistoryRepository;

  public WeightHistoryService(WeightHistoryRepository weightHistoryRepository) {
    this.weightHistoryRepository = weightHistoryRepository;
  }
  
  public List<WeightHistoryModel> getWeightHistories() throws ExecutionException, InterruptedException {
    return weightHistoryRepository.getWeightHistories();
  }
}
