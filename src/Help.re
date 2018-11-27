let display = () =>
  List.iter(
    print_endline,
    [
      "Hypatia - jsdoc to ijavascript",
      "Usage: hypatia.exe [input_file] [output_file]",
      " - input_file: jsondoc output .json file",
      " - output_file: jupyter notebook .ipynb file",
    ],
  );
