// Basic implementation of IDataSource to handle data listener
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: City[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): City {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

export interface City {
  name: string;
  timezone: string;
  offset: number;
  headerWord: string;
}

export const supportedSystemTimezone: City[] =
  [
    {
      timezone: 'Asia',
      name: 'Almaty',
      offset: 6,
      headerWord: 'A'
    },
    {
      timezone: 'America',
      name: 'Argentina',
      offset: -3,
      headerWord: 'A'
    },
    {
      timezone: 'Pacific',
      name: 'Auckland',
      offset: 12,
      headerWord: 'A'
    },
    {
      timezone: 'Europe',
      name: 'Berlin',
      offset: 2,
      headerWord: 'B'
    },
    {
      timezone: 'Asia',
      name: 'Gaza',
      offset: 3,
      headerWord: 'G'
    },
    {
      timezone: 'America',
      name: 'Godthab',
      offset: -2,
      headerWord: 'G'
    },
    {
      timezone: 'America',
      name: 'Guayaquil',
      offset: -5,
      headerWord: 'G'
    },
    {
      timezone: 'Asia',
      name: 'Jakarta',
      offset: 7,
      headerWord: 'J'
    },
    {
      timezone: 'Europe',
      name: 'Kiev',
      offset: 3,
      headerWord: 'K'
    },
    {
      timezone: 'Africa',
      name: 'Kinshasa',
      offset: 1,
      headerWord: 'K'
    },
    {
      timezone: 'Asia',
      name: 'Kuala_Lumpur',
      offset: 8,
      headerWord: 'K'
    },
    {
      timezone: 'Europe',
      name: 'Lisbon',
      offset: 1,
      headerWord: 'L'
    },
    {
      timezone: 'Europe',
      name: 'Madrid',
      offset: 2,
      headerWord: 'M'
    },
    {
      timezone: 'Pacific',
      name: 'Majuro',
      offset: 12,
      headerWord: 'M'
    },
    {
      timezone: 'Antarctica',
      name: 'McMurdo',
      offset: 12,
      headerWord: 'M'
    },
    {
      timezone: 'Europe',
      name: 'Moscow',
      offset: 3,
      headerWord: 'M'
    },
    {
      timezone: 'America',
      name: 'Mexico_City',
      offset: -5,
      headerWord: 'M'
    },
    {
      timezone: 'America',
      name: 'New_York',
      offset: -4,
      headerWord: 'N'
    },
    {
      timezone: 'Asia',
      name: 'Nicosia',
      offset: 3,
      headerWord: 'N'
    },
    {
      timezone: 'America',
      name: 'Noronha',
      offset: -2,
      headerWord: 'N'
    },
    {
      timezone: 'Pacific',
      name: 'Pohnpei',
      offset: 11,
      headerWord: 'P'
    },
    {
      timezone: 'Pacific',
      name: 'Port_Moresby',
      offset: 10,
      headerWord: 'P'
    },
    {
      timezone: 'America',
      name: 'Santiago',
      offset: -3,
      headerWord: 'S'
    },
    {
      timezone: 'Asia',
      name: 'Shanghai',
      offset: 8,
      headerWord: 'S'
    },
    {
      timezone: 'America',
      name: 'St_Johns',
      offset: -3,
      headerWord: 'S'
    },
    {
      timezone: 'America',
      name: 'Sydney',
      offset: 10,
      headerWord: 'S'
    },
    {
      timezone: 'Pacific',
      name: 'Tahiti',
      offset: -10,
      headerWord: 'T'
    },
    {
      timezone: 'Pacific',
      name: 'Tarawa',
      offset: 12,
      headerWord: 'T'
    },
    {
      timezone: 'Asia',
      name: 'Tashkent',
      offset: 5,
      headerWord: 'T'
    },
    {
      timezone: 'Asia',
      name: 'Ulaanbaatar',
      offset: 8,
      headerWord: 'U'
    },
    {
      timezone: 'Pacific',
      name: 'Wake',
      offset: 12,
      headerWord: 'W'
    },
  ];

export class MyDataSource extends BasicDataSource {
  private dataArray = supportedSystemTimezone

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): City {
    return this.dataArray[index];
  }

  public addData(index: number, data: City): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: City): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}