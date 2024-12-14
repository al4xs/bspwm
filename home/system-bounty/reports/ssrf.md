## Summary:
Hi team,
A server side request forgery vulnerability was found in one of your web assets.

Server-side request forgery (also known as SSRF) is a web security vulnerability that allows an attacker to induce the server-side application to make requests to an unintended location.

## Steps To Reproduce:

  1. Access the url changing the burp collaborator: `{{data}}`
  2. You will get a DNS Query and a HTTP Request to your server

## Resources:
`https://portswigger.net/web-security/ssrf`

## Impact

Attack can make use of ssrf to make port scan
By using this vulnerability attacker can map out attack surface
It can be used to help exploiting other vulnerabilities
A remote attacker can exploit this vulnerability by sending a specially crafted request uri-path that forwards the request to an origin server chosen by the remote user.
