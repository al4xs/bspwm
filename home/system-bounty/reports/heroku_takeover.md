# Summary

Hi team, It was detected heroku subdomain takeover at {{data}}
{{data}} is pointing to a heroku page that does not exist, therefore, It is possible to create one with it's name, allowing an attacker to takeover the subdomain.

# Steps to Reproduce

1. Open new Heroku app.
2. Choose name and region (no effect on takeover).
3. Push PoC application using git to Heroku. The process is described in Deploy tab.
4. Switch to Settings tab.
5. Scroll to Domains and certificates.
6. Click Add domain.
7. Provide the domain name of {{data}}, click Save changes.
8. It might take some time for settings to propagate.

**Security Impact**
An attacker can utilize this subdomain for targeting the organization by fake login forms, or steal sensitive information of teams (credentials, credit card information, etc)

**Fix & Mitigation**

If the subdomain is not beeing used, it should be deleted
