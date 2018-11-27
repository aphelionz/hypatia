open Ppx_deriving_yojson_runtime;

[@deriving yojson]
type kernelspec = {
  display_name: string,
  language: string,
  name: string,
};

[@deriving yojson]
type language_info = {
  file_extension: string,
  mimetype: string,
  name: string,
  version: string,
};

[@deriving yojson]
type metadata = {
  kernelspec,
  language_info,
};

[@deriving yojson]
type source = list(string);

[@deriving yojson]
type markdownCell = {
  cell_type: string,
  metadata: Yojson.Safe.json,
  source: list(string),
};

[@deriving yojson]
type codeCell = {
  cell_type: string,
  metadata: Yojson.Safe.json,
  source: list(string),
  outputs: list(string),
  execution_count: int,
};

[@deriving yojson]
type cell =
  | MarkdownCell(source)
  | CodeCell(source, list(string), int);

[@deriving yojson]
type jupyterNotebook = {
  cells: list(Yojson.Safe.json),
  metadata,
  nbformat: int,
  nbformat_minor: int,
};
