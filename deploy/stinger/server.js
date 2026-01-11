const express = require('express');
const multer = require('multer');
const { exec } = require('child_process');
require('dotenv').config();

const app = express();
const upload = multer({ dest: 'uploads/' });

app.post('/api/upload', upload.single('pack'), (req, res) => {
    const token = req.headers.authorization;
    if (token !== `Bearer ${process.env.UPLOAD_TOKEN}`) {
        return res.status(403).send('Unauthorized');
    }

    // Move file, unzip, validate, run build_pack
    console.log('File uploaded:', req.file.path);

    exec('./scripts/generate_manifest.sh', (err, stdout, stderr) => {
        if (err) console.error(err);
        console.log(stdout);
    });

    res.send('Upload received');
});

app.listen(3000, () => console.log('Stinger server running on 3000'));
