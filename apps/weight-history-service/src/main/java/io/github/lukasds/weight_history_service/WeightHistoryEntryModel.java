package io.github.lukasds.weight_history_service;

import java.util.Date;

import lombok.Value;

@Value
public class WeightHistoryEntryModel {
  Double value;
  Date timestamp;
}
