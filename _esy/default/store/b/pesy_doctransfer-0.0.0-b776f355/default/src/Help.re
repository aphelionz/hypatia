let display = () =>
  List.iter(
    print_endline,
    [
      "Doctransfer",
      "Usage: doctransfer [input_file] [output_file]",
      " - input_file: jsondoc output .json file",
      " - output_file: jupyter notebook .json file",
    ],
  );
