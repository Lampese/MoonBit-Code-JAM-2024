import * as fs from 'fs';

fs.readFile('input.txt', 'utf8', (err, data) => {
    if (err) throw err;
    const transformedData = data.replace(/0x([0-9a-fA-F]{2})/g, (match, p1) => {
        return `b'\\x${p1}'`;
    });

    fs.writeFile('output.txt', transformedData, (err) => {
        if (err) throw err;
    });
});
