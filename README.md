# hypatia 

> Converting JavaScript doctrings to ijavascript Jupyter Notebooks

## Background

Having interactive documentation in the form of Jupyter notebooks is awesome.
So is having accurate and up to date code-level documentation in the form of comments.
Wouldn't it be cool if you had a tool that transliterated js docstrings

Hypatia turns this:

[Img]

into this:

[Img]

Hypatia is built with native ReasonML and was created to manage the documentation in the `orbitdb` repositories.


## Installation
w
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


