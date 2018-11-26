# pesy-doctransfer


[![CircleCI](https://circleci.com/gh/yourgithubhandle/pesy-doctransfer/tree/master.svg?style=svg)](https://circleci.com/gh/yourgithubhandle/pesy-doctransfer/tree/master)


**Contains the following libraries and executables:**

```
pesy-doctransfer@0.0.0
│
├─test/
│   name:    TestPesyDoctransfer.exe
│   main:    TestPesyDoctransfer
│   require: pesy-doctransfer.lib
│
├─library/
│   library name: pesy-doctransfer.lib
│   namespace:    PesyDoctransfer
│   require:
│
└─executable/
    name:    PesyDoctransferApp.exe
    main:    PesyDoctransferApp
    require: pesy-doctransfer.lib
```

## Developing:

```
npm install -g esy
git clone <this-repo>
esy install
esy build
```

## Running Binary:

After building the project, you can run the main binary that is produced.

```
esy x PesyDoctransferApp.exe 
```

## Running Tests:

```
# Runs the "test" command in `package.json`.
esy test
```
