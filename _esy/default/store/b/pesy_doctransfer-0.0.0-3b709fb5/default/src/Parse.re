open Core;
open Yojson;
open Yojson.Basic;
open Yojson.Basic.Util;

let noEmptyComments = d => {
  let comment = d |> member("comment") |> to_string_option;

  switch (comment) {
  | Some(x) => String.length(x) == 0 ? false : true
  | None => false
  };
};

let createCells = d => d

let process = (input_file, output_file) => {
  let notebook = Notebook.emptyNotebook;

  let filename = "./" ++ input_file;
  let jsdoc = from_file(filename);
  let cells = jsdoc |> to_list;

  let commentCells = List.filter(~f=noEmptyComments, cells);
  let notebookCells = List.map(~f=createCells, commentCells);

  to_file(output_file, notebook);
};
