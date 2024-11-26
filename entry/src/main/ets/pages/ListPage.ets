import { MyDataSource, City, supportedSystemTimezone } from '../Data/DataSource'
import hilog from '@ohos.hilog';
PersistentStorage.persistProp<string[]>('selectedCities',[])

@Entry
@Component
export struct ListPage {
  pathStack: NavPathStack = new NavPathStack()
  // 创建数据源 上面的例子对其初始化过了
  @State dataSet: MyDataSource = new MyDataSource()
  @State filteredCities: City[] = []
  @State unfilteredCities: City[] = supportedSystemTimezone
  //For search bar
  @State changeValue: string = ''
  @State isFiltered: boolean = false
  @State isShouldFocus: boolean = false
  private controller: SearchController = new SearchController()
  @State isEnter: string = ''
  private scroller: Scroller = new Scroller()
  private alphabets: string[] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
  @State private selectedIndex: number = 0
  @StorageLink('selectedCities') selectedCities: string[] = []

  onPageShow(): void {
    AppStorage.setOrCreate("PathStack", this.pathStack)
  }

  private mapAlphabetsIndex(): Map<string, number> {
    let mapAlphabetsIndex: Map<string, number> = new Map()

    for (let i = 0; i < this.unfilteredCities.length; i++) {
      const element = this.unfilteredCities[i];
      // 第一个字母直接加入 Map
      if (i === 0) {
        mapAlphabetsIndex.set(element.headerWord, i);
      } else {
        // 如果当前字母和前一个字母不一样，则加入 Map
        if (element.headerWord != this.unfilteredCities[i - 1].headerWord) {
          mapAlphabetsIndex.set(element.headerWord, i);
        }
      }
    }
    return mapAlphabetsIndex;
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.End }) {
        Column() {
          Search({
            value: this.changeValue,
            placeholder: Object($r("app.string.search")),
            controller: this.controller,
          })
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
            List({ scroller: this.scroller }) {
              ForEach(this.unfilteredCities, (item: City, index: number) => {
                ListItem() {
                  Column() {
                    if (index == 0) {
                      // 第一个肯定要显示
                      Text(item.headerWord)
                    } else {
                      // 当前字母和前一个不一样就显示
                      if (item.headerWord != this.unfilteredCities[index-1].headerWord) {
                        Text(item.headerWord)
                      }
                    }
                    Row() {
                      Text(item.name)
                        .margin(10)
                        .fontSize(20)
                      Text(item.offset.toString())
                        .margin(10)
                        .fontSize(20)
                      if(this.selectedCities.includes(item.name)){
                        Text('City Selected!')
                      }
                    }
                    .margin(5)
                    .width('95%')
                    .height('20%')
                    .borderRadius(20)
                    .backgroundColor('#f6f6f6')
                  }
                }
                .onClick(() => {
                  if (!this.selectedCities.includes(item.name)) {
                    this.selectedCities.push(item.name);
                    this.pathStack.pop(item);
                  }
                })
              })
            }
            .onScrollIndex((start, end) => {
              // 监听滑动时顶部的索引，查询对应的数据
              const element = this.unfilteredCities[start]
              // 更新选中的字母索引
              this.selectedIndex = this.alphabets.indexOf(element.headerWord)
            })
          }
          else {
            ForEach(this.filteredCities, (item: City) => {
              ListItem() {
                Row() {
                  // Text(item.timezone)
                  //   .margin(10)
                  //   .fontSize(20)

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
        }.width('100%')
        .height('100%')

        AlphabetIndexer({ arrayValue: this.alphabets, selected: this.selectedIndex })
          .onSelect((index: number) => {
            // 选中的字母
            const alphabet = this.alphabets[index];

            // 调用 mapAlphabetsIndex，获取字母到索引的映射表
            const mapIndex = this.mapAlphabetsIndex().get(alphabet);

            if (mapIndex !== undefined) {
              // 跳转到指定索引位置
              this.scroller.scrollToIndex(mapIndex);
              hilog.info(0x00, `Selected alphabet "${alphabet}" found in the map.`, `mapIndex:${mapIndex}`);

            } else {
              hilog.error(0x00, `Selected alphabet "${alphabet}" not found in the map.`, 'error');
            }
          });

      }
    }
    .title('ListPage')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}