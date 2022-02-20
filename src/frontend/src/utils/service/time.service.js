const processVideoUploadTime = time => {
  const now = new Date();
  const uploadTime = new Date(time);

  const convertedUploadTime = new Date(
    uploadTime.getTime() - uploadTime.getTimezoneOffset() * 60 * 1000
  );

  const diff = Math.floor((now.getTime() - convertedUploadTime.getTime()) / 60000);

  let convertDay = '';

  if (diff < 60) {
    convertDay = `${diff}분 전`;
  } else if (diff <= 1440) {
    convertDay = `${Math.floor(diff / 60)}시간 전`;
  } else {
    convertDay = `${Math.floor(diff / 1440)}일 전`;
  }
  return convertDay;
};

const processChatTime = time => {
  const now = new Date(time);

  const curHour = now.getHours() + 9;
  const curMinute = String(now.getMinutes());

  const timeDivision = curHour >= 12 ? '오후' : '오전';
  const parseHour = String(curHour > 12 ? curHour - 12 : curHour);

  return `${timeDivision} ${parseHour.padStart(2, 0)}:${curMinute.padStart(2, 0)}`;
};

export default { processVideoUploadTime, processChatTime };
