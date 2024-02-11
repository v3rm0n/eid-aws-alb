# EstEID on AWS Application Load Balancer

This project is for testing if you can use mTLS functionality of the AWS Application Load Balancer with Estonian
ID cards. See also [previous attempt](https://github.com/v3rm0n/eid-aws-acm).

The answer is: you can!

Sample from the [echo service](https://github.com/mendhak/docker-http-https-echo) (Data anonymized: my IP replaced with 127.0.0.1 etc.)

```json
{
  "path": "/",
  "headers": {
    "x-forwarded-for": "127.0.0.1",
    "x-forwarded-proto": "https",
    "x-forwarded-port": "443",
    "x-amzn-mtls-clientcert-serial-number": "12DB3F24BFFD390A5CAF1A8F2712DFB4",
    "x-amzn-mtls-clientcert-issuer": "CN=ESTEID2018,organizationIdentifier=NTREE-10747013,O=SK ID Solutions AS,C=EE",
    "x-amzn-mtls-clientcert-subject": "serialNumber=PNOEE-47101010033,GN=MARILIIS,SN=M\\C3\\84NNIK,CN=M\\C3\\84NNIK\\,MARILIIS\\,47101010033,C=EE",
    "x-amzn-mtls-clientcert-validity": "NotBefore=2019-04-11T09:36:15Z;NotAfter=2024-04-10T21:59:59Z",
    "x-amzn-mtls-clientcert-leaf": "-----BEGIN%20CERTIFICATE-----REMOVED-----END%20CERTIFICATE-----%0A",
    "host": "demo.maido.io",
    "sec-ch-ua": "\"Not A(Brand\";v=\"99\", \"Google Chrome\";v=\"121\", \"Chromium\";v=\"121\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"macOS\"",
    "upgrade-insecure-requests": "1",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "sec-fetch-site": "none",
    "sec-fetch-mode": "navigate",
    "sec-fetch-user": "?1",
    "sec-fetch-dest": "document",
    "accept-encoding": "gzip, deflate, br",
    "accept-language": "en-GB,en-US;q=0.9,en;q=0.8"
  },
  "method": "GET",
  "body": "",
  "fresh": false,
  "hostname": "demo.maido.io",
  "ip": "127.0.0.1",
  "ips": [
    "127.0.0.1"
  ],
  "protocol": "https",
  "query": {},
  "subdomains": [
    "demo"
  ],
  "xhr": false,
  "os": {
    "hostname": "ip-172-31-30-96.eu-central-1.compute.internal"
  },
  "connection": {}
}
```