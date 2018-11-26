type kernelspec = {
  display_name: string,
  language: string,
  name: string,
};

type language_info = {
  file_extension: string,
  mimetype: string,
  name: string,
  version: string,
};

type metadata = {
  kernelspec,
  language_info,
};

type cellmetadata = {name: string};

type source = list(string);
type cell =
  | MarkdownCell(source)
  | CodeCell(source, list(string), int);

type jupyterNotebook = {
  cells: array(cell),
  metadata,
  nbformat: int,
  nbformat_minor: int,
};

let markdown_cell = MarkdownCell(["x", "y", "z"]);
let code_cell = CodeCell(["x", "y", "z"], [], 0);

let emptyNotebook = {
  cells: [||],
  nbformat: 4,
  nbformat_minor: 2,
  metadata: {
    kernelspec: {
      display_name: "Javascript (Node.js)",
      language: "javascript",
      name: "javascript",
    },
    language_info: {
      file_extension: ".js",
      mimetype: "application/javascript",
      name: "javascript",
      version: "10.8.0",
    },
  },
};
