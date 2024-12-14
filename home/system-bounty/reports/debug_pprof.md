# Sensitive Data Exposure via Directory Listing Enabled

# Overview of the Vulnerability

Sensitive data can be exposed by web servers which list the contents of directories that do not have an index page, which increases the exposure of files that are not intended to be accessed. Within this application, sensitive data has been exposed through a directory listing being enabled. This allows an attacker to quickly identify resources of a specific path, or gain access to data stored in the directory by browsing to the directory listing.

The debugging endpoint /debug/pprof is exposed over the unauthenticated Kubelet healthz port. This debugging endpoint can potentially leak sensitive information such as internal Kubelet memory addresses and configuration, or for limited denial of service. Versions prior to 1.15.0, 1.14.4, 1.13.8, and 1.12.10 are affected. The issue is of medium severity, but not exposed by the default configuration
Business Impact

Data exposure could result in reputational damage for the business through the impact to customers’ trust. The severity of the impact to the business is dependent on the sensitivity of the data being stored in the directory listing.

# Steps to Reproduce

    1. Using a browser, navigate to the following URL to find that directory listing is enabled: {{data}}
    2. See the information beeing leaked

**Proof of Concept (PoC)**

The screenshot below demonstrates the sensitive data found:
