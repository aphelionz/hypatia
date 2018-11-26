open Core;

open Yojson;
open Yojson.Basic;
open Yojson.Basic.Util;

open Notebook;

let noEmptyComments = d => {
  let comment = d |> member("comment") |> to_string_option;

  switch (comment) {
  | Some(x) => String.length(x) == 0 ? false : true
  | None => false
  };
};

let createCells = d => {
  let cell: cell = MarkdownCell(["x"]);
  cell;
};

let process = (input_file, output_file) => {
  let filename = "./" ++ input_file;
  let jsdoc = from_file(filename);
  let cells = jsdoc |> to_list;

  let valid_cells = List.filter(~f=noEmptyComments, cells);
  let formatted_cells = List.map(~f=createCells, valid_cells);

  let notebook = {
    cells: formatted_cells,
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

  to_file(output_file, jupyterNotebook_to_yojson(notebook));
  ();
};
