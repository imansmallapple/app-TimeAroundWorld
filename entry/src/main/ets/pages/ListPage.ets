import router from '@ohos.router'
import { MyDataSource, City } from '../Data/DataSource'

@Entry
@Component
export struct ListPage {
  pathStack: NavPathStack = new NavPathStack()
  // 创建数据源 上面的例子对其初始化过了
  @State dataSet: MyDataSource = new MyDataSource()
  onPageShow(): void {
    AppStorage.setOrCreate("PathStack", this.pathStack)
  }
  build() {
    NavDestination() {
    Scroll() {
      Column() {
        //在需要渲染的地方使用LazyForEach并传入数据源实例
        LazyForEach(this.dataSet, (item: City) => {
          ListItem() {

            Row() {
              Text(item.timezone)
                .margin(10)
                .fontSize(20)

              Text(item.name)
                .margin(10)
                .fontSize(20)

              Text(item.offset.toString())
                .margin(10)
                .fontSize(20)

              Image($r('app.media.add_icon'))
                .margin(10)
                .width('15%')
                .height('20%')
                .layoutWeight(1)
                .objectFit(ImageFit.Contain)
            }
            .margin(5)
            .width('95%')
            .height('20%')
            .borderRadius(20)
            .backgroundColor('#f6f6f6')
          }
          .onClick(() => {
            this.pathStack.pop(item); // Return to the previous page and pass in the processing result to the onPop callback of push.
          })
        })
      }
      .layoutWeight(1)
    }
      }
    .title('ListPage')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}