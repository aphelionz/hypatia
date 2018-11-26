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
  cells: list(cell),
  metadata,
  nbformat: int,
  nbformat_minor: int,
};

let markdown_cell = MarkdownCell(["x", "y", "z"]);
let code_cell = CodeCell(["x", "y", "z"], [], 0);
