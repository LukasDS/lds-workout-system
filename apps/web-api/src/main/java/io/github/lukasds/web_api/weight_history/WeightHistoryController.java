package io.github.lukasds.web_api.weight_history;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;

@CrossOrigin(origins = "http://localhost:4200")
@RestController
@RequestMapping("/weight-history")
public class WeightHistoryController {
  private final WeightHistoryService weightHistoryService;

  public WeightHistoryController(WeightHistoryService weightHistoryService) {
    this.weightHistoryService = weightHistoryService;
  }
  
  @Async
  @GetMapping("")
  public CompletableFuture<List<WeightHistoryModel>> getWeightHistories() {
    return weightHistoryService.getWeightHistories();
  }
}
