import { Component } from '@angular/core';
import { WeightHistoryRepository } from '../weight-history-repository';
import { WeightHistory } from '../weight-history';
import { TimelineChart } from '../timeline-chart/timeline-chart';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [TimelineChart],
  templateUrl: './home.html',
  styleUrl: './home.scss'
})
export class Home {
  weightHistories: WeightHistory[] = [];

  constructor(private weightHistoryRepository: WeightHistoryRepository) { }

  ngOnInit() {
    this.loadWeightHistories();
  }

  loadWeightHistories() {
    // this.weightHistoryRepository.getWeightHistories().subscribe(data => {
    //   this.weightHistories = data;
    // })

    // TODO remove after finishing the Web MVP 
    // Hardcode data to enable development of frontend without constantly calling the backend
    this.weightHistories = [
      {
        "weightName": "Abductor",
        "entries": [
          {
            "value": 18,
            "timestamp": new Date ("2025-02-01T11:06:54.624+00:00")
          },
          {
            "value": 22.5,
            "timestamp": new Date ("2025-03-17T08:53:07.900+00:00")
          },
          {
            "value": 14,
            "timestamp": new Date ("2025-01-21T14:25:18.126+00:00")
          }
        ]
      },
      {
        "weightName": "Adductor",
        "entries": [
          {
            "value": 31.5,
            "timestamp": new Date ("2025-07-07T08:53:05.783+00:00")
          },
          {
            "value": 29.3,
            "timestamp": new Date ("2025-04-03T07:44:08.755+00:00")
          },
          {
            "value": 24.8,
            "timestamp": new Date ("2025-01-21T14:24:46.126+00:00")
          },
          {
            "value": 27.3,
            "timestamp": new Date ("2025-03-12T08:27:54.288+00:00")
          }
        ]
      },
      {
        "weightName": "Aperture L",
        "entries": [
          {
            "value": 2,
            "timestamp": new Date ("2025-01-23T09:28:45.694+00:00")
          },
          {
            "value": 2,
            "timestamp": new Date ("2025-05-02T19:51:46.979+00:00")
          },
          {
            "value": 3,
            "timestamp": new Date ("2025-05-02T19:51:44.211+00:00")
          },
          {
            "value": 3.25,
            "timestamp": new Date ("2025-01-21T14:25:32.967+00:00")
          }
        ]
      },
      {
        "weightName": "Bicep curls",
        "entries": [
          {
            "value": 7,
            "timestamp": new Date ("2025-02-18T09:26:27.269+00:00")
          },
          {
            "value": 5,
            "timestamp": new Date ("2025-01-23T09:28:50.871+00:00")
          },
          {
            "value": 8.25,
            "timestamp": new Date ("2025-01-21T14:25:43.256+00:00")
          },
          {
            "value": 8,
            "timestamp": new Date ("2025-07-24T12:55:03.452+00:00")
          },
          {
            "value": 5,
            "timestamp": new Date ("2025-01-21T14:25:35.059+00:00")
          },
          {
            "value": 8,
            "timestamp": new Date ("2025-01-21T14:25:41.989+00:00")
          },
          {
            "value": 6,
            "timestamp": new Date ("2025-01-23T09:51:23.202+00:00")
          }
        ]
      },
      {
        "weightName": "Calf raises",
        "entries": [
          {
            "value": 54,
            "timestamp": new Date ("2025-02-16T09:45:08.329+00:00")
          },
          {
            "value": 60.8,
            "timestamp": new Date ("2025-04-27T12:57:27.104+00:00")
          },
          {
            "value": 58.5,
            "timestamp": new Date ("2025-04-15T19:32:31.948+00:00")
          },
          {
            "value": 63,
            "timestamp": new Date ("2025-07-20T09:24:53.273+00:00")
          },
          {
            "value": 56.3,
            "timestamp": new Date ("2025-03-17T08:59:42.428+00:00")
          },
          {
            "value": 49.5,
            "timestamp": new Date ("2025-01-21T14:25:20.460+00:00")
          },
          {
            "value": 52.5,
            "timestamp": new Date ("2025-02-01T10:53:21.482+00:00")
          }
        ]
      },
      {
        "weightName": "Deadlift",
        "entries": [
          {
            "value": 13,
            "timestamp": new Date ("2025-02-02T00:46:19.403+00:00")
          },
          {
            "value": 12.5,
            "timestamp": new Date ("2025-01-21T14:25:13.322+00:00")
          },
          {
            "value": 15,
            "timestamp": new Date ("2025-04-30T10:19:52.465+00:00")
          },
          {
            "value": 15,
            "timestamp": new Date ("2025-02-16T09:20:36.383+00:00")
          },
          {
            "value": 12,
            "timestamp": new Date ("2025-02-01T10:02:02.015+00:00")
          },
          {
            "value": 16.25,
            "timestamp": new Date ("2025-04-27T21:39:03.263+00:00")
          },
          {
            "value": 60,
            "timestamp": new Date ("2025-07-24T13:08:29.351+00:00")
          },
          {
            "value": 15,
            "timestamp": new Date ("2025-07-24T13:08:31.822+00:00")
          },
          {
            "value": 12.5,
            "timestamp": new Date ("2025-02-01T10:02:04.368+00:00")
          },
          {
            "value": 13.75,
            "timestamp": new Date ("2025-02-11T19:39:06.950+00:00")
          }
        ]
      },
      {
        "weightName": "Dips",
        "entries": [
          {
            "value": 5,
            "timestamp": new Date ("2025-01-21T14:25:40.362+00:00")
          },
        ]
      },
      {
        "weightName": "Dumbbell press",
        "entries": [
          {
            "value": 20.5,
            "timestamp": new Date ("2025-04-23T18:04:28.488+00:00")
          },
          {
            "value": 18.5,
            "timestamp": new Date ("2025-01-30T08:57:41.756+00:00")
          },
          {
            "value": 20.25,
            "timestamp": new Date ("2025-05-07T17:21:38.564+00:00")
          },
          {
            "value": 19,
            "timestamp": new Date ("2025-02-11T10:11:41.145+00:00")
          },
          {
            "value": 20,
            "timestamp": new Date ("2025-02-24T07:58:15.751+00:00")
          },
          {
            "value": 22,
            "timestamp": new Date ("2025-05-15T18:29:59.892+00:00")
          },
          {
            "value": 21,
            "timestamp": new Date ("2025-05-15T07:10:14.888+00:00")
          },
          {
            "value": 20.5,
            "timestamp": new Date ("2025-05-07T17:33:28.559+00:00")
          },
          {
            "value": 18,
            "timestamp": new Date ("2025-01-21T14:24:59.497+00:00")
          }
        ]
      },
      {
        "weightName": "Dumbbell pullovers",
        "entries": [
          {
            "value": 10,
            "timestamp": new Date ("2025-01-21T14:25:05.224+00:00")
          },
          {
            "value": 10.5,
            "timestamp": new Date ("2025-02-11T10:11:37.202+00:00")
          },
          {
            "value": 11,
            "timestamp": new Date ("2025-05-07T17:50:53.576+00:00")
          },
          {
            "value": 12,
            "timestamp": new Date ("2025-07-22T15:12:59.297+00:00")
          },
          {
            "value": 12,
            "timestamp": new Date ("2025-05-15T07:10:16.640+00:00")
          }
        ]
      },
      {
        "weightName": "Incline dumbbell flies",
        "entries": [
          {
            "value": 6.5,
            "timestamp": new Date ("2025-02-11T10:11:43.513+00:00")
          },
          {
            "value": 7,
            "timestamp": new Date ("2025-05-15T07:10:22.030+00:00")
          },
          {
            "value": 6.25,
            "timestamp": new Date ("2025-03-30T10:04:19.831+00:00")
          },
          {
            "value": 6.5,
            "timestamp": new Date ("2025-05-07T17:33:31.191+00:00")
          },
          {
            "value": 6,
            "timestamp": new Date ("2025-01-21T14:25:00.919+00:00")
          },
          {
            "value": 6.25,
            "timestamp": new Date ("2025-01-30T09:07:21.218+00:00")
          },
          {
            "value": 7,
            "timestamp": new Date ("2025-05-15T18:35:50.616+00:00")
          }
        ]
      },
      {
        "weightName": "Lat pulldowns",
        "entries": [
          {
            "value": 34.3,
            "timestamp": new Date ("2025-01-21T14:25:03.317+00:00")
          }
        ]
      },
      {
        "weightName": "Lateral raises",
        "entries": [
          {
            "value": 3,
            "timestamp": new Date ("2025-01-23T09:28:41.175+00:00")
          },
          {
            "value": 3.25,
            "timestamp": new Date ("2025-01-23T09:41:31.193+00:00")
          },
          {
            "value": 4,
            "timestamp": new Date ("2025-01-21T14:25:30.746+00:00")
          },
          {
            "value": 5,
            "timestamp": new Date ("2025-07-24T12:49:16.422+00:00")
          },
          {
            "value": 4,
            "timestamp": new Date ("2025-05-02T19:51:50.160+00:00")
          },
          {
            "value": 3,
            "timestamp": new Date ("2025-02-04T11:20:27.280+00:00")
          }
        ]
      },
      {
        "weightName": "Leg curls",
        "entries": [
          {
            "value": 13.5,
            "timestamp": new Date ("2025-07-20T08:54:31.909+00:00")
          },
          {
            "value": 22.5,
            "timestamp": new Date ("2025-03-17T08:48:32.941+00:00")
          },
          {
            "value": 21.3,
            "timestamp": new Date ("2025-01-21T14:25:16.172+00:00")
          }
        ]
      },
      {
        "weightName": "Leg extensions",
        "entries": [
          {
            "value": 23,
            "timestamp": new Date ("2025-07-22T15:49:06.343+00:00")
          },
          {
            "value": 31.5,
            "timestamp": new Date ("2025-02-07T10:04:11.007+00:00")
          },
          {
            "value": 23,
            "timestamp": new Date ("2025-07-11T21:32:31.352+00:00")
          },
          {
            "value": 24,
            "timestamp": new Date ("2025-07-24T13:07:25.334+00:00")
          },
          {
            "value": 23,
            "timestamp": new Date ("2025-07-24T13:08:09.770+00:00")
          },
          {
            "value": 29.3,
            "timestamp": new Date ("2025-01-21T14:24:43.217+00:00")
          }
        ]
      },
      {
        "weightName": "Russian twists",
        "entries": [
          {
            "value": 8,
            "timestamp": new Date ("2025-02-07T21:25:27.901+00:00")
          },
          {
            "value": 23,
            "timestamp": new Date ("2025-01-21T14:09:38.536+00:00")
          },
          {
            "value": 1,
            "timestamp": new Date ("2025-02-07T21:25:25.652+00:00")
          },
          {
            "value": 9,
            "timestamp": new Date ("2025-07-07T08:53:07.012+00:00")
          },
          {
            "value": 8,
            "timestamp": new Date ("2025-01-21T14:24:49.488+00:00")
          }
        ]
      },
      {
        "weightName": "Shoulder press",
        "entries": [
          {
            "value": 1.25,
            "timestamp": new Date ("2025-01-23T09:24:51.669+00:00")
          },
          {
            "value": 6.25,
            "timestamp": new Date ("2025-07-24T07:02:06.035+00:00")
          },
          {
            "value": 5,
            "timestamp": new Date ("2025-02-18T09:26:31.344+00:00")
          },
          {
            "value": 6.5,
            "timestamp": new Date ("2025-01-21T14:25:29.334+00:00")
          },
          {
            "value": 2.5,
            "timestamp": new Date ("2025-01-23T09:32:52.909+00:00")
          },
          {
            "value": 3.75,
            "timestamp": new Date ("2025-02-04T11:28:07.978+00:00")
          }
        ]
      },
      {
        "weightName": "Skull crushers",
        "entries": [
          {
            "value": 1.25,
            "timestamp": new Date ("2025-02-18T09:34:27.744+00:00")
          },
          {
            "value": 15,
            "timestamp": new Date ("2025-07-24T13:07:46.691+00:00")
          },
          {
            "value": 2.5,
            "timestamp": new Date ("2025-02-09T15:54:25.014+00:00")
          },
          {
            "value": 0,
            "timestamp": new Date ("2025-07-24T13:07:52.361+00:00")
          },
          {
            "value": 10,
            "timestamp": new Date ("2025-07-24T13:07:44.836+00:00")
          },
          {
            "value": 0,
            "timestamp": new Date ("2025-05-02T19:47:11.943+00:00")
          }
        ]
      },
      {
        "weightName": "Squats",
        "entries": [
          {
            "value": 11.25,
            "timestamp": new Date ("2025-05-04T10:00:40.701+00:00")
          },
          {
            "value": 10,
            "timestamp": new Date ("2025-01-21T14:24:39.559+00:00")
          },
          {
            "value": 10,
            "timestamp": new Date ("2025-02-07T10:04:13.263+00:00")
          },
          {
            "value": 7.5,
            "timestamp": new Date ("2025-01-25T09:38:59.115+00:00")
          },
          {
            "value": 8,
            "timestamp": new Date ("2025-01-25T09:18:07.514+00:00")
          },
          {
            "value": 8.25,
            "timestamp": new Date ("2025-01-25T09:48:29.765+00:00")
          }
        ]
      }
    ]
  }
}
