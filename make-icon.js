const sharp = require('sharp');
const path = require('path');

sharp(path.join(__dirname, 'icon-512.png'))
  .resize(1024, 1024, { fit: 'contain', background: { r: 92, g: 122, b: 92, alpha: 1 } })
  .toFile(path.join(__dirname, 'assets', 'icon-only.png'))
  .then(() => console.log('icon-only.png (1024x1024) erstellt'))
  .catch(err => console.error(err));
