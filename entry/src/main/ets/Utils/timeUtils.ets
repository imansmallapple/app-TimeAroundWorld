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

