import { BusinessError } from '@ohos.base';
import systemDateTime from '@ohos.systemDateTime';
import hilog from '@ohos.hilog';
import { timestampToDate, timestampToTime, timezone } from '../Utils/timeUtils'
import router from '@ohos.router';
import { City } from '../Data/DataSource';

// todo: delete function
@Entry
@Component
struct Index {
  @State timeZone: string = ''
  @State currentTime: number = 0
  @State convertedTime: string = ''
  @State convertedDate: string = ''
  intervalId: number = 0 // 定时器 ID
  @State cityList: City[] = AppStorage.get("records") ?? []
  @State isEdit: boolean = false
  @State isListEmpty: boolean = true
  scroller: Scroller = new Scroller()
  controller: TextClockController = new TextClockController();

  aboutToAppear(): void {
    try {
      systemDateTime.getTimezone((error: BusinessError, data: string) => {
        if (error) {
          hilog.error(0x0000, `Failed to get timezone. message: ${error.message}`, '%{public}s');
          return;
        }
        this.timeZone = data;
        hilog.info(0x0000, `Succeeded in get timezone : ${data}`, '%{public}s');
      });
    } catch (e) {
      let error = e as BusinessError;
      console.info(`Failed to get timezone. message: ${error.message}, code: ${error.code}`);
    }
    // const params = router.getParams() as City
    // this.cityList.push(params)
    this.startTimer(); // 启动定时器
  }

  aboutToDisappear(): void {
    this.stopTimer(); // 停止定时器
  }

  startTimer(): void {
    this.intervalId = setInterval(() => {
      try {
        systemDateTime.getCurrentTime((error: BusinessError, time: number) => {
          if (error) {
            console.info(`Failed to get currentTime. message: ${error.message}, code: ${error.code}`);
            return;
          }
          this.currentTime = time;
          this.convertedTime = timestampToTime(time);
          this.convertedDate = timestampToDate(time);
        });
      } catch (e) {
        let error = e as BusinessError;
        console.info(`Failed to get currentTime. message: ${error.message}, code: ${error.code}`);
      }
    }, 1000); // 每秒更新一次
  }

  stopTimer(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = 0;
    }
  }

  // build() {
  //   Row() {
  //     Column() {
  //       Text(`Current Zone: ${this.timeZone}`)
  //         .fontSize(50)
  //         .fontWeight(FontWeight.Bold)
  //       Text(`Current Time (Timestamp): ${this.currentTime}`)
  //         .fontSize(50)
  //         .fontWeight(FontWeight.Bold)
  //       Text(`Formatted Time: ${this.convertedTime}`)
  //         .fontSize(50)
  //         .fontWeight(FontWeight.Bold)
  //
  //       Button('Go to list')
  //         .onClick(()=>{
  //           router.pushUrl({
  //             url:'pages/ListPage'
  //           })
  //         })
  //     }
  //     .width('100%')
  //   }
  //   .height('100%')
  // }
  build() {
    Stack() {
      Column() {
        Column() {
          Text('zone1')
          Row() {
            //todo: need a function input timezone but return timezone offset
            Column() {
              Text(`${this.convertedTime}`)
                .fontSize(25)
                .fontWeight(FontWeight.Bolder)
              Text(`${this.timeZone}: ${this.convertedDate}`)
                .fontSize(18)
                .fontWeight(FontWeight.Lighter)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .width('100%')
            .height('100%')
          }
          .width('60%')
          .height('20%')
          .backgroundColor(Color.Green)
          .borderRadius(10)
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Orange)
        .width('100%')
        .height('50%')

        Column() {
          Button(this.isEdit == false && this.isListEmpty == true ? 'Edit' : 'Cancel')
            .position({})
            .onClick(() => {
              this.isEdit = (this.isEdit == false ? true : false)
            })
          Text('zone2')
          Scroll() {
            Row() {
              List({ scroller: this.scroller }) {
                ForEach(this.cityList, (item: City, index: number) => {
                  ListItem() {
                    // Row(){
                    //   Text(`${item.name}`)
                    //   Text(`${item.offset}`)
                    // }
                    Row({space: 20}) {
                      if (this.isEdit == true) {
                        Image($r('app.media.delete_icon'))
                          .height(25)
                          .onClick(()=>{
                            this.cityList.splice(index, 1);
                           // console.log(`item id:${index}`)
                          })
                      }
                      Text(`${item.name}`)
                        .fontWeight(FontWeight.Bold)
                        .fontSize(20)
                      TextClock({ timeZoneOffset: item.offset, controller: this.controller })
                        .layoutWeight(1)
                        .align(Alignment.End)
                        .margin(10)
                    }
                    .height(70)
                    .margin({
                      bottom:10
                    })
                  }
                })
              }
            }
            .zIndex(1)
            .backgroundColor(Color.Brown)
          }
          .margin({
            top: 20
          })
        }
        .backgroundColor(Color.Blue)
        .width('90%')
        .height('45%')
      }

      Button('+')
        .zIndex(1)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ListPage'
          })
        })
    }
    .alignContent(Alignment.Bottom)
  }
}
