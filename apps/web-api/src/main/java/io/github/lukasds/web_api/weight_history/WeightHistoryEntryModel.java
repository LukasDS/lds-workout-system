package io.github.lukasds.web_api.weight_history;
import java.util.Date;

import lombok.Value;

@Value
public class WeightHistoryEntryModel {
  Double value;
  Date timestamp;
}
