open Yojson;

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

Js.log(code_cell);
Js.log(markdown_cell);

/*
 let createCell = (cell_type, source) => {
   switch (cell_type) {
     | "markdown" => {
       cell_type: cell_type,
       source: source,
       outputs: None,
       execution_count: None
     }
     | "code" => {
       cell_type: cell_type,
       source: source,
       outputs: Some([||]),
       execution_count: Some(0) }
     | _ => raise(Not_found)
   }
 }
 */

let jupyterNotebook = {
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

let main_parse_file = filename => {
  let jsdoc = Pervasives.open_in("./" ++ filename);

  let file_stream =
    Stream.from(_i =>
      switch (Pervasives.input_line(jsdoc)) {
      | line => Some(line)
      | exception End_of_file => None
      }
    );

  file_stream |> Stream.iter(line => print_string(line));
};

let () =
  switch (Sys.argv) {
  | [|_|] => Help.display()
  | [|_, filename|] => main_parse_file(filename)
  | _ => Help.display()
  };
