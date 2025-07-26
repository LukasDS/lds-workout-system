import { TestBed } from '@angular/core/testing';

import { WeightHistoryRepository } from './weight-history-repository';

describe('WeightHistory', () => {
  let service: WeightHistoryRepository;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(WeightHistoryRepository);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
