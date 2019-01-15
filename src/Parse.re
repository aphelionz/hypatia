open Core;
open Console;

open Yojson.Safe;
open Yojson.Safe.Util;

open AST;
open Notebook;

let desc = ast =>  "\n" ++ ast.description ++ "\n\n";

let title = ast =>
  "# "
  ++ ast.longname
  ++ "
<small>"
  ++ ast.scope
  ++ " "
  ++ ast.kind
  ++ "</small>";

let params = ast =>
  ["| Param | Type | Description | \n", "|-----|-----|----|"] @
  List.map(
    ~f=
      param => {
        let nameList =
          switch (param.paramType) {
          | None => ""
          | Some(paramType) =>
            paramType.names
            |> List.fold_left(~f=(a, b) => a ++ " " ++ b, ~init="")
          };
        "\n| **" ++ param.name ++ "** | " ++ nameList ++ "|" ++ param.description ++ "|";
      },
    ast.params,
  );

let returns = ast =>
  List.map(
    ~f=
      return => {
        let nameList =
          switch (return.paramType) {
          | None => ""
          | Some(paramType) =>
            paramType.names
            |> List.fold_left(~f=(a, b) => a ++ " " ++ b, ~init="")
          };
        "\n\n**Returns: " ++ nameList ++ "** - " ++ ast.description;
      },
    ast.returns,
  );


let createCells = ast => [
  MarkdownCell([title(ast), desc(ast)] @ params(ast) @ returns(ast)),
  CodeCell(ast.examples, [], 0),
];

let expandCells = cell =>
  switch (cell) {
  | MarkdownCell(source) =>
    markdownCell_to_yojson({
      cell_type: "markdown",
      metadata: from_string("{}"),
      source,
    })
  | CodeCell(source, outputs, execution_count) =>
    codeCell_to_yojson({
      cell_type: "code",
      source,
      metadata: from_string("{}"),
      outputs,
      execution_count,
    })
  };

let process = (input_file, output_file) => {
  let filename = "./" ++ input_file;
  let jsdoc = from_file(filename);
  let cells =
    jsdoc
    |> to_list
    |> List.map(~f=astItem_of_yojson)
    |> List.map(~f=ast =>
         switch (ast) {
         | Error(result) =>
           Console.log(result);
           [];
         | Ok(ast) => [ast]
         }
       )
    |> ListLabels.flatten
    |> List.filter(~f=ast => !ast.undocumented)
    |> List.map(~f=createCells)
    |> ListLabels.flatten
    |> List.map(~f=expandCells);

  let notebook = {
    cells,
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

  /*
   jupyterNotebook.cells.unshift(jupyterNotebook.cells.pop())
   */
  to_file(output_file, Notebook.jupyterNotebook_to_yojson(notebook));
  ();
};
