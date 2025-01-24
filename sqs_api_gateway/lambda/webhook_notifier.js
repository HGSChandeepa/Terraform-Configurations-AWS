const https = require('https');

exports.handler = async (event) => {
  const webhookUrl = process.env.WEBHOOK_URL;
  
  for (const record of event.Records) {
    const message = record.body;
    
    const options = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      }
    };

    await new Promise((resolve, reject) => {
      const req = https.request(webhookUrl, options, (res) => {
        res.on('data', () => {});
        res.on('end', resolve);
      });
      
      req.on('error', reject);
      req.write(JSON.stringify({ message: message }));
      req.end();
    });
  }
  
  return { status: 'OK' };
};