import { BusinessError } from '@ohos.base';
import systemDateTime from '@ohos.systemDateTime';
import hilog from '@ohos.hilog';
import { timestampToDate, timestampToTime, timezone } from '../Utils/timeUtils'
import router from '@ohos.router';
import { City, supportedSystemTimezone } from '../Data/DataSource';
import { ListPage } from './ListPage'

// todo: delete function
@Entry
@Component
struct Index {
  @State timeZone: string = ''
  @State currentTime: number = 0
  @State convertedTime: string = ''
  // @State convertedDate: string = ''
  intervalId: number = 0 // 定时器 ID
  //todo: test if we can remove appStorage to store city
  @State cityList: City[] = AppStorage.get("records") ?? []
  @State isEdit: boolean = false
  @State isListEmpty: boolean = true
  scroller: Scroller = new Scroller()
  controller: TextClockController = new TextClockController();
  @State currentTimeZoneOffset: number = 0
  @State convertedDate: string = AppStorage.get("Date") as string
  pathStack: NavPathStack = new NavPathStack()
  @State message: string = ''
  @State citylist: City[] = []
  @Builder
  PagesMap(name: string) {
    if (name == 'Index') {
      Index()
    } else if (name == 'ListPage') {
      ListPage()
    }
  }

  aboutToAppear(): void {
    try {
      systemDateTime.getTimezone((error: BusinessError, data: string) => {
        if (error) {
          hilog.error(0x0000, `Failed to get timezone. message: ${error.message}`, '%{public}s');
          return;
        }
        this.timeZone = data;
        this.currentTimeZoneOffset = (this.getTimezoneOffsetByName(this.timeZone) as number) * -1
        hilog.info(0x0000, `Succeeded in get timezone : ${data}`, '%{public}s');
      });
    } catch (e) {
      let error = e as BusinessError;
      console.info(`Failed to get timezone. message: ${error.message}, code: ${error.code}`);
    }
    // const params = router.getParams() as City
    // this.cityList.push(params)
    this.startTimer(); // 启动定时器
    // 全局设置一个NavPathStack
    AppStorage.setOrCreate("PathStack", this.pathStack)
  }

  onPageShow(): void {
    // this.pathStack = AppStorage.get("PathStack") as NavPathStack
    // hilog.info(0x0,JSON.stringify(this.pathStack),"abcdefg")
    // hilog.info(0x0000, 'testTag', '%{public}s', `abcdefg:${this.pathStack}`)
    // console.log("AAA " + this.cityList.toString())
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
          this.convertedDate = timestampToDate(time);
          this.convertedTime = timestampToTime(time);
          AppStorage.setOrCreate("Date", this.convertedDate);
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

  getTimezoneOffsetByName(systemTimeZone: string): number | null {
    // Find the matching city based on the name
    let name = this.extractRegion(systemTimeZone)
    const city = supportedSystemTimezone.find(city => city.name === name);

    // Return the offset if found, or null if not found
    return city ? city.offset : null;
  }

  private extractRegion(timezone: string): string | null {
    if (timezone.includes('/')) {
      return timezone.split('/')[1]; // Return the part before the '/'
    }
    return null; // Return null if the format is invalid
  }

  build() {
    Navigation(this.pathStack) {

      Stack() {
        Column() {
          Column() {
            Row() {
              Column() {
                TextClock({ timeZoneOffset: this.currentTimeZoneOffset, controller: this.controller })
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
            Scroll() {
              Row() {
                List({ scroller: this.scroller }) {
                  ForEach(this.citylist, (item: City, index: number) => {
                    ListItem() {
                      Row({ space: 20 }) {
                        if (this.isEdit == true) {
                          Image($r('app.media.delete_icon'))
                            .height(25)
                            .onClick(() => {
                              this.citylist.splice(index, 1);
                              // console.log(`item id:${index}`)
                            })
                        }
                        Text(`${item.name}`)
                          .fontWeight(FontWeight.Bold)
                          .fontSize(20)
                        TextClock({ timeZoneOffset: item.offset * -1, controller: this.controller })
                          .layoutWeight(1)
                          .align(Alignment.End)
                          .margin(10)
                      }
                      .height(70)
                      .margin({
                        bottom: 10
                      })
                    }
                  })
                }
              }
              .zIndex(1)
              .backgroundColor(Color.Brown)
            }
            .margin({
              top: 40
            })
          }
          .backgroundColor(Color.Blue)
          .width('90%')
          .height('45%')
        }
        Text(`message:${this.message}`)
        Button('+')
          .zIndex(1)// .onClick(() => {
            //   this.pathStack.pushPathByName('ListPage', '');
            //   // router.pushUrl({
            //   //   url: 'pages/ListPage'
            //   // })
            // })
          .onClick(() => {
            let tmp!: City
            this.pathStack.pushPathByName('ListPage', tmp, (popInfo) => {
              this.message = '[pushPathByName]last page is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result);
              let city = popInfo.result as City
              this.message = city.name
              this.citylist.push(city)
            }); // Push the navigation destination page specified by name, with the data specified by param, to the navigation stack. Use the onPop callback to receive the page processing result.
          })
      }
      .alignContent(Alignment.Bottom)
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title('Index')
    .navDestination(this.PagesMap)
  }
}
