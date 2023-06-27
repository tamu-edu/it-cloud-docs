# Github

## Security GH Automation

This is a shared account that is used for github automation.  This account has several components:

- a shared NetID
- a github.com account

The shared netID can be managed [here](https://gateway.tamu.edu/settings/proxy/).  The github.com account can be managed like a normal github user at [github](https://github.com).  This shared account has access to should to the `tamu_edu` organization.  Credentials for both can be found in [TAMU's 1password](https://tamu.1password.com/) vault.  Logging into github:

1) Navigate to <https://gitub.com/tamu-edu/> -> click 'Sign in'

  ```admonish note
  Be sure to login using incognito, a private window or a separate profile from your TAMU login.
  ```

2) You will be prompted to login with the github.com credentials (see 1password)
3) Next you will be prompted for 'Two-factor' authtentication.  These can be found in 1password as well, under 'one-time password'
4) Lastly, you will be prompted to 'Single sign-on to Texas A&M University'.  Click 'continue' -> login with the shared NetID credential

The purpose of the account is to allow github actions, to trigger a workflow from within a workflow run.  You can only trigger another workflow run from within github using a using a personal access token(PAT).  The shared github account allows you to push code to a repo and trigger a new workflow using the `on:push` event.  Otherwise a recursive workflow might occur.

## Monthly Report Repo PAT

The 'it-sec-monthly-reports' repo uses a personal access token (PAT) from 'sec-gh-automation' user to trigger workflows in github actions.  The PAT is named 'Security Monthly Report' and has `read:org, read:packages, repo` permissions.  This token expires every 90 days. Before the expiration, a notification will be sent to 'sec-gh-automation@tamu.edu' which delivers to the 'cloudsecurity@tamu.edu' distribution list.  Follow the on-screen instructions to save renew the PAT (or do nothing to let it expire).