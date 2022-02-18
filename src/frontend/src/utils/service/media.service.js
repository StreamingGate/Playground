import { toast } from 'react-toastify';

const getImagePreviewURl = image => {
  return new Promise(resolve => {
    if (image.files && image.files[0]) {
      const reader = new FileReader();

      reader.onload = e => {
        resolve(e.target.result);
      };

      reader.readAsDataURL(image.files[0]);
    }
  });
};

const copyUrl = async () => {
  const toastOption = { position: 'top-right', autoClose: 3000 };
  try {
    await navigator.clipboard.writeText(window.location.href);
    toast.dismiss();
    toast.success('주소가 복사되었습니다', toastOption);
  } catch (error) {
    toast.dismiss();
    toast.warn('주소를 복사하지 못했습니다', toastOption);
  }
};

const defaultProfileBgColors = [
  '#FFCB46',
  '#5690E7',
  '#D696EC',
  '#ED6464',
  '#909090',
  '#93DDB1',
  '#55CFC8',
  '#F16E9D',
];

const createImageFromInitials = name => {
  const size = 100;
  const firstLetter = name[0];

  const canvas = document.createElement('canvas');
  const context = canvas.getContext('2d');
  canvas.width = size;
  canvas.height = size;

  const randomIdx = Math.floor(Math.random() * defaultProfileBgColors.length);

  context.fillStyle = defaultProfileBgColors[randomIdx];
  context.fillRect(0, 0, size, size);

  context.fillStyle = `#ffffff50`;
  context.fillRect(0, 0, size, size);

  context.fillStyle = '#ffffff';
  context.textBaseline = 'middle';
  context.textAlign = 'center';
  context.font = `${size / 2}px Roboto`;
  context.fillText(firstLetter, size / 2, size / 2);

  return canvas.toDataURL();
};

export default { getImagePreviewURl, createImageFromInitials, copyUrl };
