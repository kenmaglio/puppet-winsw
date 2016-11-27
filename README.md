# winsw

#### NOTES TO SELF
In order for puppet agent without a puppet master to find my module "installed"
From directory  C:\ProgramData\PuppetLabs\code\environments\production\modules
mklink /D winsw D:\_kenmaglio\puppet-winsw 




#### Table of Contents

1. [Important](#important)
1. [Description](#description)
1. [Setup - The basics of getting started with winsw](#setup)
    * [Beginning with winsw](#beginning-with-winsw)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Important

If you change the $service_id value, after you have installed the service, and you do not ensure abscent first, you will cause errors.
The reason is because the code which tried to uninstall, will already have been effected


## Description

This module encapsulates all functionality of the WinSW service application wrapper.
The development of that module is accredited: https://github.com/kohsuke/winsw

This module attempts to allow any executable with any arguments to be wrapped in a Windows Service.
This will require files to be placed on the system in a managed path: EXE, XML, EXE.Config

Supported Commands:
* install (ensure=>abscent = uninstall)
* service

### Beginning with winsw



## Usage



## Reference



## Limitations



## Development

