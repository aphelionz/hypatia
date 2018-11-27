# hypatia 

> Converting JavaScript doctrings to ijavascript Jupyter Notebooks

## Background

Having interactive documentation in the form of Jupyter notebooks is awesome.
So is having accurate and up to date code-level documentation in the form of comments.
Wouldn't it be cool if you had a tool that transliterated js docstrings

Hypatia turns this:

```
/**
 * @description
 * Log implements a G-Set CRDT and adds ordering
 * Create a new Log instance
 *
 * From:
 * "A comprehensive study of Convergent and Commutative Replicated Data Types"
 * https://hal.inria.fr/inria-00555588
 *
 * @constructor
 *
 * @example
 * const IPFS = require("ipfs")
 * const Log = require("../src/log")
 * const { AccessController, IdentityProvider } = require("../src/log")
 * const Keystore = require('orbit-db-keystore')
 * const Entry = require("../src/entry")
 * const Clock = require('../src/lamport-clock')
 *
 * const accessController = new AccessController()
 * const ipfs = new IPFS();
 * const keystore = Keystore.create("../test/fixtures/keys")
 * const identitySignerFn = async (id, data) => {
 *   const key = await keystore.getKey(id)
 *   return keystore.sign(key, data)
 * }
 *
 * (async () => {
 *   var identity = await IdentityProvider.createIdentity(keystore, 'username', identitySignerFn)
 *   var log = new Log(ipfs, accessController, identity)
 *
 *   // console.log(Object.keys(log))
 * })()
 *
 *
 * @param  {IPFS}           [ipfs]          An IPFS instance
 * @param  {Object}         [access]        AccessController (./default-access-controller)
 * @param  {Object}         [identity]      Identity (https://github.com/orbitdb/orbit-db-identity-provider/blob/master/src/identity.js)
 * @param  {String}         [logId]         ID of the log
 * @param  {Array<Entry>}   [entries]       An Array of Entries from which to create the log
 * @param  {Array<Entry>}   [heads]         Set the heads of the log
 * @param  {Clock}          [clock]         Set the clock of the log
 * @return {Log}                            Log
 */
```

into this:

![Jupyter Notebook version of the above code](./doc/jupyter-screenshot.png)

Hypatia is built with native ReasonML and was created to manage the documentation in the `orbitdb` repositories.


## Installation

### Prerequisites: `esy` and `pesy`

Hypatia currently requires the `esy` and `pest` tools to build and run.

### Installation Steps
```
git clone https://github.com/aphelionz/hypatia.git
esy install
esy pesy
esy build
```

## Usage

The binary is available 

After building the project, you can run the main binary that is produced.

The current recommendation is to create two jupyter notebooks in your projects

```
esy x hypatia
```

## Contributing

Feel free to ask questions via issues. PRs are accepted.

## License


