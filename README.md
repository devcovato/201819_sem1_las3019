# University of Malta - PLAS/LAS3019 2018/19

> **Tested only on Windows 10, but should work also on Linux and Mac with minor tweaks**
>
> **NOTE** There is an assumption that the below software is known

[LAS3019](https://www.um.edu.mt/courses/studyunit/las3019) - Blockchain and Smart Contract Programming

## Table Of Contents

- [Intro](#intro)
- [Vagrant](#vagrant)
- [Truffle Project](#truffle-project)
- [Notes](#notes)
- [Known Issues](#known-issues)
- [License](#license)

## Intro

To start developing on Ethereum the following software is required:

> NOTE The below software is installed using [chocolatey](https://chocolatey.org/).

- [vagrant](https://www.vagrantup.com/) (version at writing moment: 2.2.1)
- [virtualbox](https://www.virtualbox.org/) (version at writing moment: 5.2.22)
- [git](https://git-scm.com/) (version at writing moment: 2.19.1). The chocolatey package name `git.install`
- [openssh](https://github.com/PowerShell/Win32-OpenSSH) (version at writing moment: 7.7.2.1)
- [visual studio code](https://code.visualstudio.com/) as editor or whatever you like

## Vagrant

To get a functional `vagrant` the following tested plugin are required:

- vagrant-vbguest
- vagrant-hostmanager

To save download time use the plugin `vagrant-cachier` and define the following environment variables:

- `VAGRANT_SF_SMB_HOST` is the IP host to connect to, for example `10.0.2.2`
- `VAGRANT_SF_SMB_USERNAME` is the user name allowed to map the remote folder
- `VAGRANT_SF_SMB_PASSWORD` is the user password

The plugin `vagrant-cachier` is configured to be optional.

## Truffle Project

> **NOTE**
>
> - The default folder project name is `trufflebox-webpack`. If you want to change then edit the file `Vagrantfile`
> - Keep in mind that at this stage any sub-folder under `projects` will be deleted if you create the machine the first time

The folder `projects` is mounted as shared folder into the vagrant box as `/home/vagrant/sf_projects`.

Before running a `truffle` project, already set up for you, apply the following tweaks:

- file `package.json` changes the script `dev` with `webpack-dev-server --public 201819-sem1-las3019.test:8080 --host 0.0.0.0`
- file `app/scripts/index.js` replaces `127.0.0.1` with `201819-sem1-las3019.test`
- file `truffle.js` changes host and port respectively with `201819-sem1-las3019.test` and `9545`

In order to run a Web3 provider for testing/developing run `ganache-cli --host 0.0.0.0 --port 9545`.

The above changes about host come in handy to avoid the ports remapping and potentially some side-effects.

## Notes

- you can find the project `trufflebox-webpack` in the vagrant box under `/home/vagrant/sf_projects`
- use `byobu` to split the screen and running multiple commands
- open your favourite browser at <http://201819-sem1-las3019.test:8080>

## Known Issues

- VirtualBox cannot work when Hyper-v is enabled. Read the followings how to disable or apply an alternative solution:
  - <https://www.hanselman.com/blog/SwitchEasilyBetweenVirtualBoxAndHyperVWithABCDEditBootEntryInWindows81.aspx> or
  - <http://rizwanansari.net/run-hyper-v-and-virtualbox-on-the-same-machine/>
- Slow ssh connection running `vagrant ssh`. Set up the environment variable `VAGRANT_PREFER_SYSTEM_BIN` equals to 1
- Failure to change the file hosts or mount shared folder. Run `vagrant` command with administrative permission (aka run administration console)

## License

The content of this project itself is licensed under the [Creative Commons Attribution 3.0 Unported license](https://creativecommons.org/licenses/by/3.0/), and the underlying source code used to format and display that content is licensed under the [MIT license](LICENSE.md).
