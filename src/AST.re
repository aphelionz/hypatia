open Ppx_deriving_yojson_runtime;

open Yojson.Safe.Util;

[@deriving of_yojson]
type paramType = {names: [@default []] list(string)};

[@deriving of_yojson { strict: false }]
type return = {
  description: [@default None] option(string),
  [@key "type"]
  paramType: [@default None] option(paramType),
};

[@deriving of_yojson { strict: false }]
type param = {
  [@key "type"]
  paramType: [@default None] option(paramType),
  optional: [@default false] bool,
  description: [@default ""] string,
  name: [@default ""] string,
};

[@deriving of_yojson { strict: false }]
type metaCode = {
  id: [@default ""] string,
  name: [@default ""] string,
  [@key "type"]
  codeType: [@default ""] string,
  paramnames: [@default []] list(string)
};

[@deriving of_yojson { strict: false }]
type meta = {
  range: [@default []] list(int),
  filename: [@default ""] string,
  lineno: [@default 0] int,
  columnno: [@default 0] int,
  path: [@default ""] string,
  [@key "code"]
  metaCode: [@default None] option(metaCode),
};

[@deriving of_yojson { strict: false }]
type astItem = {
  name: [@default ""] string,
  longname: [@default ""] string,
  undocumented: [@default false] bool,
  comment: [@default ""] string,
  description: [@default ""] string,
  kind: [@default ""] string,
  scope: [@default ""] string,
  examples: [@default []] list(string),
  params: [@default []] list(param),
  meta: [@default None] option(meta),
  memberof: [@default ""] string,
  async: [@default false] bool,
  returns: [@default []] list(return)
};
