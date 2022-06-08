# Matic SDK

[![GitHub version](https://badge.fury.io/gh/maticnetwork%2Fmatic.js.svg)](https://badge.fury.io/gh/maticnetwork%2Fmatic.js)
![Build Status](https://github.com/maticnetwork/matic.js/workflows/CI/badge.svg?branch=master)
[![npm version](https://badge.fury.io/js/%40maticnetwork%2Fmaticjs.svg)](https://badge.fury.io/js/%40maticnetwork%2Fmaticjs)
![GitHub](https://img.shields.io/github/license/maticnetwork/matic.js)
[![TEST](https://github.com/maticnetwork/matic.js/actions/workflows/test.yml/badge.svg)](https://github.com/maticnetwork/matic.js/actions/workflows/test.yml)

This repository contains the `maticjs` client library. `maticjs` makes it easy for developers, who may not be deeply familiar with smart contract development, to interact with the various components of Matic Network.

This library will help developers to move assets from Ethereum chain to Matic chain, and withdraw from Matic to Ethereum using fraud proofs.

## Docs

https://maticnetwork.github.io/matic.js

## Support

Our [Discord](https://discord.gg/s2NPJNUvyc) is the best way to reach us ✨.

## Contributors

You are very welcome to contribute, please see contributing guidelines - [[Contribute](CONTRIBUTING.MD)].

Thank you to all the people who already contributed to matic.js!

<a href="https://github.com/maticnetwork/matic.js/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=maticnetwork/matic.js" />
</a>

Made with [contributors-img](https://contrib.rocks).

## Development

**Setup**

```bash
npm ci
```

**How to debug**

Write your code inside file `test/debug.js` and run below code

```bash
npm run debug
```

Above command will build the source code & install the builded version into test folder, which will be used by `debug.js`.

**Lint**

```bash
# To check lint errors
npm run lint

# To fix most common lint errors
# Note that it might not fix all errors, some need manual intervention
npm run lint:fix
```

**Build code**

```bash
npm run build
```

**Run test**

```bash
npm run test
```

**Generate distribution files**

```bash
npm run deploy
```

**NPM publish**

Before running publish script, make sure you have updated version properly.

Note that `prepublishOnly` script will be automatically called while publishing. It will check lint, clean dist/lib folders and build fresh distribution files before it executes `npm publish`.

```bash
npm publish
```

### License

MIT
