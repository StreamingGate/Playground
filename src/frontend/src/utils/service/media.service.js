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

export default { getImagePreviewURl };
