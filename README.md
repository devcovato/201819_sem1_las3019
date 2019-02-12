# University of Malta - PLAS/LAS3019 2018/19

> **Tested only on Windows 10, but should work also on Linux and Mac with minor tweaks**
>
> **NOTE** There is an assumption that the below software is known

[LAS3019](https://www.um.edu.mt/courses/studyunit/las3019) - Blockchain and Smart Contract Programming

## Table Of Contents

- [Intro](#intro)
  - [Vagrant](#vagrant)
- [Project Organization](#project-organization)
- [Truffle Project Development](#truffle-project-development)
- [Tips and Tricks](#tips-and-tricks)
- [Known Issues](#known-issues)
- [License](#license)

## Intro

To start developing on Ethereum the following software is required:

> NOTE The below software is installed using [chocolatey](https://chocolatey.org/).

- [vagrant](https://www.vagrantup.com/) (version at writing moment: 2.2.2)
- [virtualbox](https://www.virtualbox.org/) (version at writing moment: 5.2.22)
- [git](https://git-scm.com/) (version at writing moment: 2.19.1). The chocolatey package name `git.install`
- [openssh](https://github.com/PowerShell/Win32-OpenSSH) (version at writing moment: 7.7.2.1)
- [visual studio code](https://code.visualstudio.com/) (version at writing moment: 1.30.2) as editor or whatever you like

### Vagrant

To get a functional `vagrant` the following tested plugin are required:

- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
- [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)

To save download time for guest machine use the plugin [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier) and define the following environment variables:

- `VAGRANT_SF_SMB_HOST` is the IP host to connect to, for example `10.0.2.2`
- `VAGRANT_SF_SMB_USERNAME` is the user name allowed to map the remote folder
- `VAGRANT_SF_SMB_PASSWORD` is the user password

The plugin `vagrant-cachier` is configured to be optional.

## Project Organization

Below the project organization:

```shell
<current_folder>
|   .editorconfig
|   .gitignore
|   LICENSE.md
|   README.md
|
+---projects
|       .gitignore
|
\---vagrant
    |   Vagrantfile
    |
    \---scripts
            install-geth.sh
            install-node-nvm.sh
            install-nvm.sh
            install-truffle.sh
            provision.sh
            setup-devenv.sh
            setup-trufflebox.sh
```

The `projects` folder contains `truffle` projects only. Additionally, the folder `projects` is mounted as shared folder into the vagrant box as `/home/vagrant/sf_projects`.

## Truffle Project Development

By default the script `setup-trufflebox.sh` creates a new `truffle` project named `trufflebox-webpack`. Moreover, the file `trufflebox-webpack.lock` is created to avoid overriding the project already set up. So, if you want to recreate the project than delete the `lock` file.

To set up a different project name and/or `truffle` box applies the following change:

```ruby
    exec env TRUFFLEBOX_PROJECT_NAME='my-project' "$BASH" -il /vagrant/scripts/setup-trufflebox.sh
    # or
    exec env TRUFFLEBOX_NAME='webpack' "$BASH" -il /vagrant/scripts/setup-trufflebox.sh
    # or
    exec env TRUFFLEBOX_PRJNAME='my-project' env TRUFFLEBOX_NAME='webpack' "$BASH" -il /vagrant/scripts/setup-trufflebox.sh
```

In case of `webpack` box, before running a `truffle` project apply the following tweaks:

- file `package.json` changes the script `dev` with `webpack-dev-server --public 201819-sem1-las3019.test:8080 --host 0.0.0.0`
- file `app/src/index.js` replaces `127.0.0.1` with `201819-sem1-las3019.test`
- file `app/truffle-config.js` add the following network configuration:

    ```javascript
    development: {
      host: '0.0.0.0',
      port: 8545,
      network_id: '*' // Match any network id
    }
    ```

- run `ganache-cli --host 0.0.0.0 --port 8545`, a Web3 provider for testing/development
- run `truffle console --network development` in another terminal. Then `migrate --reset`

The above changes about host come in handy to avoid the ports remapping and potentially some side-effects.

## Tips and Tricks

- use `byobu` to split the screen and running multiple commands
- open your favourite browser at <http://201819-sem1-las3019.test:8080>
- to grab `ganache` accounts, create a log file, and keeping the output on screen invoke `ganache-cli` as follow:

  ```bash
  ganache-cli --host 0.0.0.0 | tee ganache.log | tee >(head -n 40 > ganache-accounts.txt) -p
  # or
  ganache-cli --host 0.0.0.0 | tee >(head -n 40 > ganache-accounts.txt) -p | tee ganache.log
  # or keep the same accounts
  ganache-cli --host 0.0.0.0 --mnemonic "las3019 blockchain ethereum dlt" | tee ganache.log | tee >(head -n 40 > ganache-accounts.txt) -p
  ```

## Known Issues

- VirtualBox cannot work when Hyper-v is enabled. Read the followings how to disable or apply an alternative solution:
  - <https://www.hanselman.com/blog/SwitchEasilyBetweenVirtualBoxAndHyperVWithABCDEditBootEntryInWindows81.aspx> or
  - <http://rizwanansari.net/run-hyper-v-and-virtualbox-on-the-same-machine/>
- Slow ssh connection running `vagrant ssh`. Set up the environment variable `VAGRANT_PREFER_SYSTEM_BIN` equals to 1
- Failure to change the file hosts or mount shared folder. Run `vagrant` command with administrative permission (aka run administration console)
- running `npm -g ls --depth=0` provides some warnings like below

  ```shell
  vagrant@201819-sem1-las3019:~$  npm -g ls --depth=0
  /home/vagrant/.nvm/versions/node/v10.14.1/lib
  +-- ganache-cli@6.2.3
  +-- node-gyp@3.8.0
  +-- npm@6.4.1
  +-- solc@0.4.25
  +-- truffle@5.0.0

  npm ERR! invalid: websocket@1.0.26 /home/vagrant/.nvm/versions/node/v10.14.1/lib/node_modules/ganache-cli/node_modules/ganache-core/node_modules/web3-providers-ws/node_modules/websocket
  npm ERR! invalid: ethereumjs-abi@0.6.5 /home/vagrant/.nvm/versions/node/v10.14.1/lib/node_modules/ganache-cli/node_modules/ganache-core/node_modules/eth-tx-summary/node_modules/eth-sig-util/node_modules/ethereumjs-abi
  npm ERR! invalid: ethereumjs-abi@0.6.5 /home/vagrant/.nvm/versions/node/v10.14.1/lib/node_modules/ganache-cli/node_modules/ganache-core/node_modules/web3-provider-engine/node_modules/eth-sig-util/node_modules/ethereumjs-abi
  ```

- running bash script provide the warning message "bash: cannot set terminal process group (8598): Inappropriate ioctl for device"

## License

The content of this project itself is licensed under the [Creative Commons Attribution 3.0 Unported license](https://creativecommons.org/licenses/by/3.0/), and the underlying source code used to format and display that content is licensed under the [MIT license](LICENSE.md).
