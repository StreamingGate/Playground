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

const createImageFromInitials = (name, bgColor, color) => {
  const size = 100;
  const firstLetter = name[0];

  const canvas = document.createElement('canvas');
  const context = canvas.getContext('2d');
  canvas.width = size;
  canvas.height = size;

  context.fillStyle = bgColor;
  context.fillRect(0, 0, size, size);

  context.fillStyle = `${color}50`;
  context.fillRect(0, 0, size, size);

  context.fillStyle = color;
  context.textBaseline = 'middle';
  context.textAlign = 'center';
  context.font = `${size / 2}px Roboto`;
  context.fillText(firstLetter, size / 2, size / 2);

  return canvas.toDataURL();
};

export default { getImagePreviewURl, createImageFromInitials };
