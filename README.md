# 1password-env-vars

A Bash script that will help you use 1password data to manage your Cloud provider CLI credentials.

---

First up, HT and thanks to [Grant Orchard](https://github.com/grantorchard) & [Anthony Burke](https://github.com/pandom). Grant because he wrote [this thing here](https://grantorchard.com/securing-environment-variables-with-1password/) which I was able to use to give me a head-start making this thing. Anthony because he introduced me to Grant's widget.

I've had a task in my personal project queue for a long time to write something like this. I was sick of having to manually key in my Cloud CLI credentials and chop and change them as I moved between various Cloud Platforms and tenancies.

---

## introduction

This script will accept a search string (enclosed in double-quotes) and list matching entries in your selected 1password vault.

```bash
😀 abest@BARMIX2:~ $ source ./.import_envvars.sh "Env Vars"
Enter the password for XXXX@XXXX.XXXX at XXXXXXXX.1password.com: 
Please select an entry:
1) Env Vars - AWS - Example
2) Env Vars - AWS - NAME0 - ENV
3) Env Vars - Azure - Company.com - Dev - SP
#?
```

You can then select the entry you want to insert the credentials for into your current CLI session.

```bash
😀 abest@BARMIX2:~ $ source ./.import_envvars.sh "Env Vars"
Enter the password for XXXX@XXXX.XXXX at XXXXXXXX.1password.com: 
Please select an entry:
1) Env Vars - AWS - Example
2) Env Vars - AWS - NAME0 - ENV
3) Env Vars - Azure - Company.com - Dev - SP
#? 2
Setting environment variable VAULT_ADDR
Setting environment variable AWS_REGION
Setting environment variable AWS_ACCESS_KEY_ID
Setting environment variable AWS_SECRET_ACCESS_KEY
```

## requirements

* You need a [1password](https://1password.com/) account.
* You need the [1password CLI](https://support.1password.com/command-line-getting-started/) installed and configured.
* A bash shell that supports associative arrays. Bash v4 and newer iirc.

## setup

* satisfy the requirements 
* grab the bash script
* modify the `TENANT_ID` variable and enter your 1password tenant name.
* make sure the script is executable `chmod 700 .import_envvars.sh`

## usage

* see the example in the intro
* have a look at Grant's page for some information about the formatting and contents of the 1password item.

## caveats

* No warranties
* Dont come to me if it blows up your stuff
* Take it as is
* be kind
