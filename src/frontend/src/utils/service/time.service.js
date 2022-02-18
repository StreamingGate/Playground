const processVideoUploadTime = time => {
  const now = new Date();
  const uploadTime = new Date(time);

  const convertedUploadTime = new Date(
    uploadTime.getTime() - uploadTime.getTimezoneOffset() * 60 * 1000
  );

  const seconds = Math.floor((now - convertedUploadTime) / 1000);
  let difference = seconds / 31536000;

  if (difference > 1) {
    return `${Math.floor(difference)}년 전`;
  }

  difference = seconds / 2592000;
  if (difference > 1) {
    return `${Math.floor(difference)}개월 전`;
  }

  difference = seconds / 86400;
  if (difference > 1) {
    return `${Math.floor(difference)}일 전`;
  }

  difference = seconds / 3600;
  if (difference > 1) {
    return `${Math.floor(difference)}시간 전`;
  }

  return `${Math.floor(difference)}분 전`;
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
