## Summary:
Hi team,

It was found a xss reflected in your web asset.

Reflected Cross-site Scripting (XSS) occur when an attacker injects browser executable code within a single HTTP response.When a web application is vulnerable to this type of attack, it will pass unvalidated input sent through requests back to the client.

## Steps To Reproduce:

  1. Access the url `{{data}}`
  2. See the popup in the screen

## Supporting Material/References:
[list any additional material (e.g. screenshots, logs, etc.)]

  * [attachment / reference]

## Impact
* An attacker that can control the code executed in a victim browser can usually fully compromise this victim. This includes :
* Perform any action within the application that the user can perform.
* Modify any information that the user is able to modify.
* Steal user cookies
* Redirect to phishing site
* Arbitrary requests - An attacker can use XSS to send requests that appear to be from the victim to the web server.
* Malware download - XSS can prompt the user to download malware. Since the prompt looks like a legitimate request from the
site, the user may be more likely to trust the request and actually install the malware.
* Run Arbitrary javascript code into victim's browser
