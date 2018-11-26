let () =
  switch (Sys.argv) {
  | [|_|] => Help.display()
  | [|_, input_file, output_file|] => Parse.process(input_file, output_file)
  | _ => Help.display()
  };
