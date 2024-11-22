import I18n from '@ohos.i18n';

export function timestampToDate(timestamp: number): string {
  const date = new Date(timestamp); // 将时间戳转为 Date 对象

  // 格式化时间
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从 0 开始，需要加 1
  const day = String(date.getDate()).padStart(2, '0');

  // 拼接成需要的格式
  return `${year}-${month}-${day}`;
}

export function timestampToTime(timestamp: number): string {
  const date = new Date(timestamp); // 将时间戳转为 Date 对象

  // 格式化时间
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  // 拼接成需要的格式
  return `${hours}:${minutes}:${seconds}`;
}


// 获取巴西时区
export let timezone = I18n.getTimeZone("America/Sao_Paulo"); // 传入特定时区，创建时区类
let timezoneId = timezone.getID();// America/Sao_Paulo

// 获取城市Id对应的时区对象
let aucklandTimezone = I18n.TimeZone.getTimezoneFromCity("Auckland");
let aucklandTzId = aucklandTimezone.getID(); // Pacific/Auckland

// 时区的本地化名称
let timeZoneName = timezone.getDisplayName("zh-Hans", true); // 巴西利亚标准时间

// 本地化城市名称
let cityDisplayName = I18n.TimeZone.getCityDisplayName("Auckland", "zh-Hans") // 奥克兰（新西兰）

// 时区的固定偏移量
let rawOffset = timezone.getRawOffset(); // -10800000

// 时区的实际偏移量(固定偏移量+夏令时)
let offset = timezone.getOffset(1234567890);// -10800000

// 系统支持的时区Id列表
let ids = I18n.TimeZone.getAvailableIDs(); // ["America/Adak", "Asia/Hovd", "America/Sao_Paulo", "Asia/Jerusalem", "Europe/London",...]

// 系统支持的时区城市Id列表
let cityIdArray = I18n.TimeZone.getAvailableZoneCityIDs();  // ["Auckland", "Magadan", "Lord Howe Island",...]
// 遍历时区城市Id列表
let timezoneList: Array<object> = [];  // 呈现给用户的时区列表
class Item {
  cityDisplayName : string = "";
  timezoneId : string = "";
  offset : string = "";
  cityId : string = ""
}
for (let i =0 ; i < cityIdArray.length ; i++) {
  let cityId = cityIdArray[i];
  let timezone = I18n.TimeZone.getTimezoneFromCity(cityId); // 城市Id对应的时区对象
  let cityDisplayName = I18n.TimeZone.getCityDisplayName(cityId, "zh-CN"); // 本地化城市名称
  let timestamp = (new Date()).getTime()
  let item : Item = {
    cityDisplayName : cityDisplayName,
    timezoneId : timezone.getID(),
    offset : 'GMT'+ (timezone.getOffset(timestamp) / 3600*1000),
    cityId : cityId
  }
  timezoneList.push(item);
}

// 指定地理坐标所在的时区对象数组
let timezoneArray = I18n.TimeZone.getTimezonesByLocation(-43.1, -22.5)
for (let i =0;i < timezoneArray.length; i++) {
  let tzId = timezoneArray[i].getID(); // America/Sao_Paulo
}
