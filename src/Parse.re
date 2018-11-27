open Core;

open Yojson.Safe;
open Yojson.Safe.Util;

open Notebook;

let snag = (target, parserFn, default, d) => {
  let json = d |> member(target);

  switch (json) {
  | `Null => default
  | _ => json |> parserFn
  };
};

let comment = d => d |> snag("comment", to_string, "");

let title = d => {
  let longname = snag("longname", to_string, "", d);
  let scope = snag("scope", to_string, "", d);
  let kind = snag("kind", to_string, "", d);

  "# " ++ longname ++ " <small>" ++ scope ++ " " ++ kind ++ "</small>";
};

let desc = d => d |> snag("description", to_string, "");
let params = d => {
  let paramsList = snag("params", to_list, [], d);

  List.map(
    ~f=
      d => {
        let name = snag("name", to_string, "", d);
        let namesList = d |> member("type") |> snag("names", to_list, []);
        let description = snag("description", to_string, "", d);
        let names =
          namesList
          |> List.map(~f=to_string)
          |> List.fold_left(~f=(a, b) => a ++ " " ++ b, ~init="");

        "\n* **" ++ name ++ "** " ++ names ++ " " ++ description;
      },
    paramsList,
  );
};
let examples = d => d |> snag("examples", to_list, []) |> filter_string;

let returns = d => {
  let returnsList = snag("returns", to_list, [], d);

  List.map(
    ~f=
      d => {
        let namesList = d |> member("type") |> snag("names", to_list, []);
        let description = snag("description", to_string, "", d);
        let names =
          namesList
          |> List.map(~f=to_string)
          |> List.fold_left(~f=(a, b) => a ++ " " ++ b, ~init="");

        "\n\n**Returns: " ++ names ++ "** - " ++ description;
      },
    returnsList,
  );
};

let createCells = d => [
  MarkdownCell([title(d), desc(d)] @ params(d) @ returns(d)),
  /* CodeCell(examples(d), [], 0), */
];

let expandCells = cell =>
  switch (cell) {
  | MarkdownCell(source) =>
    markdownCell_to_yojson({cell_type: "markdown", source})
  | CodeCell(source, outputs, execution_count) =>
    codeCell_to_yojson({cell_type: "code", source, outputs, execution_count})
  };

let process = (input_file, output_file) => {
  let filename = "./" ++ input_file;
  let jsdoc = from_file(filename);
  let cells =
    jsdoc
    |> to_list
    |> List.filter(~f=d => String.length(comment(d)) != 0)
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
