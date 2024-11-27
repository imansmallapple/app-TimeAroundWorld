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
      timezone: 'Africa',
      name: 'Accra',
      offset: 0,
      headerWord: 'A'
    },
    {
      timezone: 'Africa',
      name: 'Algiers',
      offset: 1,
      headerWord: 'A'
    },
    {
      timezone: 'Africa',
      name: 'Asunción',
      offset: -3,
      headerWord: 'A'
    },
    {
      timezone: 'Africa',
      name: 'Addis Ababa',
      offset: 3,
      headerWord: 'A'
    },
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
      timezone: 'Europe',
      name: 'Amsterdam',
      offset: 1,
      headerWord: 'A'
    },
    {
      timezone: 'Europe',
      name: 'Athens',
      offset: 2,
      headerWord: 'A'
    },
    {
      timezone: 'Pacific',
      name: 'Auckland',
      offset: 13,
      headerWord: 'A'
    },
    {
      timezone: 'Europe',
      name: 'Azores',
      offset: -1,
      headerWord: 'A'
    },
    {
      timezone: 'Africa',
      name: 'Banjul',
      offset: 0,
      headerWord: 'B'
    },
    {
      timezone: 'Asia',
      name: 'Beijing',
      offset: 8,
      headerWord: 'B'
    },
    {
      timezone: 'Africa',
      name: 'Bucharest',
      offset: 2,
      headerWord: 'B'
    },
    {
      timezone: 'Africa',
      name: 'Bujumbura',
      offset: 2,
      headerWord: 'B'
    },
    {
      timezone: 'Africa',
      name: 'Bangui',
      offset: 1,
      headerWord: 'B'
    },
    {
      timezone: 'Europe',
      name: 'Białystok',
      offset: 1,
      headerWord: 'B'
    },
    {
      timezone: 'Europe',
      name: 'Berlin',
      offset: 1,
      headerWord: 'B'
    },
    {
      timezone: 'Africa',
      name: 'Casablanca',
      offset: 0,
      headerWord: 'C'
    },
    {
      timezone: 'Africa',
      name: 'Cairo',
      offset: 2,
      headerWord: 'C'
    },
    {
      timezone: 'Africa',
      name: 'Conakry',
      offset: 0,
      headerWord: 'C'
    },
    {
      timezone: 'Europe',
      name: 'Copenhagen',
      offset: 1,
      headerWord: 'C'
    },
    {
      timezone: 'Europe',
      name: 'Dublin',
      offset: 0,
      headerWord: 'D'
    },
    {
      timezone: 'Europe',
      name: 'Douala',
      offset: 1,
      headerWord: 'D'
    },
    {
      timezone: 'Europe',
      name: 'Dhaka',
      offset: 6,
      headerWord: 'D'
    },
    {
      timezone: 'Europe',
      name: 'Edinburgh',
      offset: 0,
      headerWord: 'E'
    },
    {
      timezone: 'Europe',
      name: 'Ekaterinburg',
      offset: 5,
      headerWord: 'E'
    },
    {
      timezone: 'Europe',
      name: 'El Aaiún',
      offset: 0,
      headerWord: 'E'
    },

    {
      timezone: 'Africa',
      name: 'Freetown',
      offset: 0,
      headerWord: 'F'
    },
    {
      timezone: 'Europe',
      name: 'Faro',
      offset: 0,
      headerWord: 'F'
    },
    {
      timezone: 'Asia',
      name: 'Gaza',
      offset: 2,
      headerWord: 'G'
    },
    {
      timezone: 'Europe',
      name: 'Gdańsk',
      offset: 1,
      headerWord: 'G'
    },

    {
      timezone: 'America',
      name: 'Guayaquil',
      offset: -5,
      headerWord: 'G'
    },
    {
      timezone: 'Africa',
      name: 'Harare',
      offset: 2,
      headerWord: 'H'
    },
    {
      timezone: 'Africa',
      name: 'Helsinki',
      offset: 2,
      headerWord: 'H'
    },
    {
      timezone: 'Asia',
      name: 'Islamabad',
      offset: 5,
      headerWord: 'I'
    },
    {
      timezone: 'Asia',
      name: 'Istanbul',
      offset: 3,
      headerWord: 'I'
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
      offset: 2,
      headerWord: 'K'
    },
    {
      timezone: 'Africa',
      name: 'Kinshasa',
      offset: 1,
      headerWord: 'K'
    },
    {
      timezone: 'Africa',
      name: 'Kigali',
      offset: 2,
      headerWord: 'K'
    },
    {
      timezone: 'Europe',
      name: 'Kraków',
      offset: 1,
      headerWord: 'K'
    },
    {
      timezone: 'Asia',
      name: 'Kuala Lumpur',
      offset: 8,
      headerWord: 'K'
    },
    {
      timezone: 'Europe',
      name: 'Lisbon',
      offset: 0,
      headerWord: 'L'
    },
    {
      timezone: 'Africa',
      name: 'Lagos',
      offset: 1,
      headerWord: 'L'
    },
    {
      timezone: 'Africa',
      name: 'Luanda',
      offset: 1,
      headerWord: 'L'
    },
    {
      timezone: 'Africa',
      name: 'Lima',
      offset: -5,
      headerWord: 'L'
    },
    {
      timezone: 'Europe',
      name: 'London',
      offset: 0,
      headerWord: 'L'
    },
    {
      timezone: 'Europe',
      name: 'Madrid',
      offset: 1,
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
      name: 'Mexico City',
      offset: -6,
      headerWord: 'M'
    },
    {
      timezone: 'Asia',
      name: 'Nairobi',
      offset: 3,
      headerWord: 'N'
    },
    {
      timezone: 'America',
      name: 'New York',
      offset: -5,
      headerWord: 'N'
    },
    {
      timezone: 'America',
      name: 'Nuuk',
      offset: -2,
      headerWord: 'N'
    },
    {
      timezone: 'Asia',
      name: 'Nicosia',
      offset: 2,
      headerWord: 'N'
    },
    {
      timezone: 'America',
      name: 'Noronha',
      offset: -2,
      headerWord: 'N'
    },
    {
      timezone: 'Europe',
      name: 'Oslo',
      offset: 1,
      headerWord: 'O'
    },
    {
      timezone: 'Africa',
      name: 'Ouagadougou',
      offset: 0,
      headerWord: 'O'
    },
    {
      timezone: 'Asia',
      name: 'Oman',
      offset: 4,
      headerWord: 'O'
    },
    {
      timezone: 'Europe',
      name: 'Paris',
      offset: 1,
      headerWord: 'P'
    },
    {
      timezone: 'Pacific',
      name: 'Pohnpei',
      offset: 11,
      headerWord: 'P'
    },
    {
      timezone: 'Pacific',
      name: 'Port Moresby',
      offset: 10,
      headerWord: 'P'
    },
    {
      timezone: 'Europe',
      name: 'Poznań',
      offset: 1,
      headerWord: 'P'
    },
    {
      timezone: 'Asia',
      name: 'Qatar',
      offset: 3,
      headerWord: 'Q'
    },
    {
      timezone: 'Europe',
      name: 'Quito',
      offset: -5,
      headerWord: 'Q'
    },
    {
      timezone: 'Europe',
      name: 'Rome',
      offset: 1,
      headerWord: 'R'
    },
    {
      timezone: 'Europe',
      name: 'Reykjavik',
      offset: 0,
      headerWord: 'R'
    },
    {
      timezone: 'America',
      name: 'Santiago',
      offset: -4,
      headerWord: 'S'
    },
    {
      timezone: 'Asia',
      name: 'Shanghai',
      offset: 8,
      headerWord: 'S'
    },
    {
      timezone: 'Europe',
      name: 'Szczecin',
      offset: 1,
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
      timezone: 'Europe',
      name: 'Utrecht',
      offset: 1,
      headerWord: 'U'
    },
    {
      timezone: 'Asia',
      name: 'Urumqi',
      offset: 6,
      headerWord: 'U'
    },
    {
      timezone: 'Asia',
      name: 'Ulaanbaatar',
      offset: 8,
      headerWord: 'U'
    },
    {
      timezone: 'Africa',
      name: 'Vientiane',
      offset: 7,
      headerWord: 'V'
    },
    {
      timezone: 'Europe',
      name: 'Vienna',
      offset: 1,
      headerWord: 'V'
    },
    {
      timezone: 'Europe',
      name: 'Vilnius',
      offset: 2,
      headerWord: 'V'
    },
    {
      timezone: 'Africa',
      name: 'Windhoek',
      offset: 1,
      headerWord: 'W'
    },
    {
      timezone: 'Africa',
      name: 'Wellington',
      offset: 12,
      headerWord: 'W'
    },
    {
      timezone: 'Pacific',
      name: 'Wake',
      offset: 12,
      headerWord: 'W'
    },
    {
      timezone: 'Europe',
      name: 'Warsaw',
      offset: 1,
      headerWord: 'W'
    },
    {
      timezone: 'Europe',
      name: 'Wrocław',
      offset: 1,
      headerWord: 'W'
    },
    {
      timezone: 'Asia',
      name: 'Xiamen',
      offset: 8,
      headerWord: 'X'
    },
    {
      timezone: 'Africa',
      name: 'Xalapa',
      offset: -6,
      headerWord: 'X'
    },
    {
      timezone: 'Africa',
      name: 'Yamoussoukro',
      offset: 0,
      headerWord: 'Y'
    },
    {
      timezone: 'Asia',
      name: 'Yerevan',
      offset: 4,
      headerWord: 'Y'
    },
    {
      timezone: 'Asia',
      name: 'Yekaterinburg',
      offset: 5,
      headerWord: 'Y'
    },
    {
      timezone: 'Africa',
      name: 'Yaoundé',
      offset: 1,
      headerWord: 'Y'
    },
    {
      timezone: 'Europe',
      name: 'Zagreb',
      offset: 1,
      headerWord: 'Z'
    },
    {
      timezone: 'Europe',
      name: 'Zurich',
      offset: 1,
      headerWord: 'Z'
    },
    {
      timezone: 'Africa',
      name: 'Zanzibar',
      offset: 3,
      headerWord: 'Z'
    },
    {
      timezone: 'Africa',
      name: 'Zamboanga',
      offset: 8,
      headerWord: 'Z'
    }
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