export interface Area {
  timezone: string;
  name: string;
}

export interface TimeZoneResponse {
  year: number;
  month: number;
  day: number;
  hour: number;
  minute: number;
  seconds: number;
  milliSeconds: number;
  dateTime: string;
  date: string;
  time: string;
  timeZone: string;
  dayOfWeek: string;
  dstActive: boolean;
}

export function parseTimeZone(timezoneStr: string): Area {
  const parts = timezoneStr.split("/"); // 使用 '/' 拆分字符串
  const timezone = parts[0]; // 主区域部分
  const name = parts[1]; // 替换下划线为空格
  return {
    timezone: timezone,
    name: name,
  };
}