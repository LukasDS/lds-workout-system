package io.github.lukasds.web_api.weight_history;

import java.util.List;

import lombok.Value;

@Value
public class WeightHistoryModel {
  String weightName;
  List<WeightHistoryEntryModel> entries;
}
