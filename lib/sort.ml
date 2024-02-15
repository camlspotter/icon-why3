(** Sorts for the FOL theory used as the assertion language *)

open Error_monad
open Why3
open Ptree

type t = Sort of pty

let equal a b = a = b

let compare (t1 : t) (t2 : t) = compare t1 t2

(** Pretty printer *)
let pp_sort ppf (Sort ty) = (Mlw_printer.pp_pty ~attr:true).closed ppf ty

let string_of_sort (ty : t) : string =
  let open Format in
  asprintf "%a"
    (fun ppf ty ->
      (* ignore newlines and indents automatically inserted by pretty printing *)
      pp_set_formatter_out_functions ppf
        {
          (pp_get_formatter_out_functions ppf ()) with
          out_newline = ignore;
          out_indent = ignore;
        };
      pp_sort ppf ty)
    ty

let sort_of_pty (pty : pty) : t =
  (* We must drop the location info and etc. for equality *)
  let open Ptree in
  let norm_id id = { id with id_ats= []; id_loc= Loc.dummy_position } in
  let rec norm_qualid = function
    | Qident id -> Qident (norm_id id)
    | Qdot (qid, id) -> Qdot (norm_qualid qid, norm_id id)
  in
  let rec norm = function
    | PTtyvar id -> PTtyvar (norm_id id)
    | PTtyapp (qualid, ptys) -> PTtyapp (norm_qualid qualid, List.map norm ptys)
    | PTtuple ptys -> PTtuple (List.map norm ptys)
    | PTref ptys -> PTref (List.map norm ptys)
    | PTarrow (pty, pty') -> PTarrow (norm pty, norm pty')
    | PTscope (qualid, pty) -> PTscope (norm_qualid qualid, norm pty)
    | PTparen pty -> PTparen (norm pty)
    | PTpure pty -> PTpure (norm pty)
  in
  Sort (norm pty)

let pty_of_sort (Sort pty : t) : Ptree.pty = pty
