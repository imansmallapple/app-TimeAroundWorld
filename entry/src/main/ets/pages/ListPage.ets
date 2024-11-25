import { MyDataSource, City, supportedSystemTimezone } from '../Data/DataSource'
import { KeyCode } from '@ohos.multimodalInput.keyCode';

@Entry
@Component
export struct ListPage {
  pathStack: NavPathStack = new NavPathStack()
  // 创建数据源 上面的例子对其初始化过了
  @State dataSet: MyDataSource = new MyDataSource()
  @State filteredCities: City[] = []
  //For search bar
  @State changeValue: string = ''
  @State isFiltered: boolean = false
  @State isShouldFocus: boolean = false
  private controller: SearchController = new SearchController()
  @State isEnter: string = ''

  onPageShow(): void {
    AppStorage.setOrCreate("PathStack", this.pathStack)
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Text(`Enter:${this.isEnter}`)
          Search({
            value: this.changeValue,
            placeholder: Object($r("app.string.search")),
            controller: this.controller,
          })
            .searchButton(// getContext(this).resourceManager.getStringSync($r("app.string.search"))
              "Search"
            )
            .focusable(true)
            .width("100%")
            .height(40)
            .backgroundColor("#F5F5F5")
            .placeholderColor(Color.Grey)
            .placeholderFont({ size: 14, weight: 400 })
            .textFont({ size: 14, weight: 400 })
            .onChange((value: string) => {
              this.changeValue = value
              if (value == '') {
                this.isFiltered = false
              }
              this.isFiltered = true
              // 搜索逻辑：过滤数据集中的城市名称
              const filteredCity = supportedSystemTimezone.filter((city: City) => {
                return city.name.toLowerCase().includes(value.toLowerCase())
                  || city.timezone.toLowerCase().includes(value.toLowerCase())
              });
              this.filteredCities = filteredCity
            })
            .onSubmit((value: string) => {
              this.isFiltered = true
              // 搜索逻辑：过滤数据集中的城市名称
              const filteredCity = supportedSystemTimezone.filter((city: City) => {
                return city.name.toLowerCase().includes(value.toLowerCase())
                  || city.timezone.toLowerCase().includes(value.toLowerCase())
              });
              this.filteredCities = filteredCity
            })
            .onTouch(() => {
              this.isShouldFocus = true
            })
            .focusable(this.isShouldFocus);
          //在需要渲染的地方使用LazyForEach并传入数据源实例
          if (!this.isFiltered) {

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

                  // Image($r('app.media.add_icon'))
                  //   .margin(10)
                  //   .width('15%')
                  //   .height('20%')
                  //   .layoutWeight(1)
                  //   .objectFit(ImageFit.Contain)
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
          else {
            ForEach(this.filteredCities, (item: City) => {
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

                  // Image($r('app.media.add_icon'))
                  //   .margin(10)
                  //   .width('15%')
                  //   .height('20%')
                  //   .layoutWeight(1)
                  //   .objectFit(ImageFit.Contain)
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